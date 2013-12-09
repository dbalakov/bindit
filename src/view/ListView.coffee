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

    if model == viewValue && event == BindIt.Model.Events.VALUE_CHANGED && isNumber(field)
      itemElement = @itemsElements.get(@itemsSubscribes.get(oldValue))
      return @itemView.changed value, itemElement if value? && itemElement?

    if model == viewValue && arrayEvent == BindIt.Model.ArrayEvents.INSERTED
      element = @createItemElement value
      return @element.appendChild element if index == model.length - 1
      return @element.insertBefore element, @element.childNodes[index]

    if model == viewValue && arrayEvent == BindIt.Model.ArrayEvents.REMOVED
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
    @element.removeChild @element.childNodes[0] while @element.childNodes? && @element.childNodes.length > 0
    value = @getValue true
    return if !value?

    fragment = document.createDocumentFragment()
    for item in value
      element = @createItemElement(item)
      fragment.appendChild element
    @element.appendChild fragment

  createItemElement: (item)->
    element = @itemView.create(item)
    @itemsElements.add item, element
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