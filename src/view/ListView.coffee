class ListView extends BindIt.View
  constructor: (@element) ->
    super @element
    @calculateItemView()
    return if !@itemView?

    @itemsSubscribes = new BindIt.Hash
    @itemsElements = []
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
    index = viewValue.indexOf(item) if arrayEvent != BindIt.Model.ArrayEvents.INSERTED && arrayEvent != BindIt.Model.ArrayEvents.REMOVED
    itemElement = @itemsElements[index]
    if item? && itemElement?
      index = viewValue.indexOf item
      return @itemView.changed(itemElement, viewValue, index, viewValue.selectedItem == index, viewValue.selectedItems.indexOf(index) >= 0) if item? && itemElement?

    if model == viewValue && event == BindIt.Model.Events.VALUE_CHANGED
      if field == 'length'
        if oldValue < value
          for index in [oldValue..(value - 1)]
            @element.appendChild @createItemElement(model, index)
          return
        else
          while @element.childNodes[value]?
            node = @element.childNodes[@element.childNodes.length - 1]
            @element.removeChild node
          @itemsElements.length = value
          return

      if field == 'selectedItem'
        @itemView.changed(@itemsElements[oldValue], viewValue, oldValue, false, viewValue.selectedItems.indexOf(oldValue) >= 0)
        @itemView.changed(@itemsElements[value], viewValue, value, true, viewValue.selectedItems.indexOf(oldValue) >= 0)
        return

      if field == 'selectedItems'
        diff = []
        diff.push(item) for item in oldValue
        diff.push(item) for item in value
        @itemView.changed(@itemsElements[index], viewValue, index, index == viewValue.selectedItem, viewValue.selectedItems.indexOf(index) >= 0) for index in [0..diff.length-1] if diff.length > 0
        return

      if isNumber(field)
        index = parseInt field
        itemElement = @itemsElements[index]
        return @itemView.changed(itemElement, viewValue, index, viewValue.selectedItem == index, viewValue.selectedItems.indexOf(index) >= 0) if value? && itemElement?

    if model == viewValue.selectedItems
      if arrayEvent == BindIt.Model.ArrayEvents.INSERTED
        itemElement = @itemsElements[value]
        @itemView.changed(itemElement, viewValue, value, viewValue.selectedItem == value, viewValue.selectedItems.indexOf(value) >= 0)
        return

      if arrayEvent == BindIt.Model.ArrayEvents.REMOVED
        itemElement = @itemsElements[value]
        @itemView.changed(itemElement, viewValue, value, viewValue.selectedItem == value, viewValue.selectedItems.indexOf(value) >= 0)
        return

      if event == BindIt.Model.Events.VALUE_CHANGED
        if isNumber(field)
          @itemView.changed(@itemsElements[oldValue], viewValue, oldValue, viewValue.selectedItem == oldValue, viewValue.selectedItems.indexOf(oldValue) >= 0)
          @itemView.changed(@itemsElements[value], viewValue, value, viewValue.selectedItem == value, viewValue.selectedItems.indexOf(value) >= 0)
          return

    if model == viewValue && arrayEvent == BindIt.Model.ArrayEvents.INSERTED
      element = @createItemElement model, index
      return @element.appendChild element if index == model.length - 1
      return @element.insertBefore element, @element.childNodes[index]
      return

    if model == viewValue && arrayEvent == BindIt.Model.ArrayEvents.REMOVED
      @itemsElements.splice value, 1
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
    @itemsElements = []

    value = @getValue true
    return if !value?

    fragment = document.createDocumentFragment()
    fragment.appendChild(@createItemElement(value, index)) for index in [0..value.length-1] if value.length > 0
    @element.appendChild fragment

  createItemElement: (value, index)->
    element = @itemView.create value, index, value.selectedItem == index, value.selectedItems.indexOf(index) >= 0
    @itemsElements.splice(index, 0, element)
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