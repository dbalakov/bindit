class ListView extends BindIt.View
  constructor: (@element) ->
    super @element
    @calculateItemView()
    return if !@itemView?

    @itemsSubscribes = new BindIt.Hash
    @itemsElements = new BindIt.Hash
    @changed()

  changed:(view, model, event) ->
    field      = if event == BindIt.Model.Events.VALUE_CHANGED then arguments[3] else null
    oldValue   = if event == BindIt.Model.Events.VALUE_CHANGED then arguments[4] else null
    value      = arguments[5]
    arrayEvent = if event == BindIt.Model.Events.VALUE_CHANGED then null else arguments[3]
    index      = if event == BindIt.Model.Events.VALUE_CHANGED then null else arguments[4]

    @callChanged(model, event, arrayEvent, index, field, oldValue, value)
    @refreshItemsSubscribes()

  callChanged:(model, event, arrayEvent, index, field, oldValue, value)->
    viewValue = @getValue true

    item = @itemsSubscribes.get(model)
    itemElement = @itemsElements.get(item)
    return @itemView.changed item, itemElement if item? && itemElement?

    if model == viewValue && event == BindIt.Model.Events.VALUE_CHANGED
      if field == 'length'
        if oldValue < value
          @element.appendChild(@createItemElement(model, index)) for index in [oldValue..(value - 1)]
          return
        else
          while @element.childNodes[value]?
            node = @element.childNodes[@element.childNodes.length - 1]
            @itemsElements.remove @itemsElements.getKeyByValue node
            @element.removeChild node
          return

      if isNumber(field)
        itemElement = @itemsElements.get(@itemsSubscribes.get(oldValue))
        return @itemView.changed value, itemElement if value? && itemElement?

    if model == viewValue && arrayEvent == BindIt.Model.ArrayEvents.INSERTED
      element = @createItemElement model, index
      return @element.appendChild element if index == model.length - 1
      return @element.insertBefore element, @element.childNodes[index]

    if model == viewValue && arrayEvent == BindIt.Model.ArrayEvents.REMOVED
      @itemsElements.remove value
      return @element.removeChild @element.childNodes[index]

    @apocalyptic()

  calculateItemView: ->
    if !@element.hasAttribute(ListView.ITEM_VIEW_ATTRIBUTE)
      BindIt.Logger.warn "BindIt.View.ListView: element hasn't '#{ListView.ITEM_VIEW_ATTRIBUTE}' attribute", @element
      return

    path = @element.getAttribute(ListView.ITEM_VIEW_ATTRIBUTE)
    try
      @itemView = eval path
    catch e
      BindIt.Logger.warn "BindIt.View.ListView: invalid '#{ListView.ITEM_VIEW_ATTRIBUTE}' attribute", @element
      return
    BindIt.Logger.warn "BindIt.View.ListView: invalid '#{ListView.ITEM_VIEW_ATTRIBUTE}' attribute", @element if !@itemView?

  apocalyptic:->
    @element.removeChild(@element.firstChild) while @element.firstChild?
    @itemsElements.clear()

    value = @getValue true
    return if !value?

    fragment = document.createDocumentFragment()
    fragment.appendChild(@createItemElement(value, index)) for index in [0..value.length-1] if value.length > 0
    @element.appendChild fragment

  createItemElement: (value, index)->
    item = value[index]
    element = @itemView.create value, item
    @itemsElements.add(item, element) if item?
    element

  refreshItemsSubscribes:->
    value = @getValue true
    return if !value?
    @itemsSubscribes.clear()
    for item in value
      if item?
        subscribes = []
        @fillSubscribes item, subscribes, true
        @itemsSubscribes.add subscribe, item for subscribe in subscribes


isNumber = (value)->
  i = parseInt value
  return i == value

ListView.ITEM_VIEW_ATTRIBUTE = 'item-view'

BindIt.View.List = ListView