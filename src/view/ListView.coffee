class ListView extends BindIt.View
  constructor: (@element) ->
    super @element
    @calculateItemView()
    return if !@itemView?

    @apocalyptic()

  changed:(view, model, event, field, oldValue, value) ->
    console.log 'arguments', arguments
    @apocalyptic()

  calculateItemView: ->
    if !@element.hasAttribute(ListView.ITEM_VIEW_ATTRIBUTE)
      BindIt.Logger.warn "BindIt.ListView: element hasn't '#{ListView.ITEM_VIEW_ATTRIBUTE}' attribute", @element
      return

    path = @element.getAttribute(ListView.ITEM_VIEW_ATTRIBUTE)
    try
      @itemView = eval path
    catch e
      BindIt.Logger.warn "BindIt.ListView: invalid '#{ListView.ITEM_VIEW_ATTRIBUTE}' attribute", @element
      return
    BindIt.Logger.warn "BindIt.ListView: invalid '#{ListView.ITEM_VIEW_ATTRIBUTE}' attribute", @element if !@itemView?

  apocalyptic:->
    @element.removeChild @element.childNodes[0] while @element.childNodes? && @element.childNodes.length > 0
    value = @getValue true
    return if !value?

    for item in value
      element = @itemView.create(item)
      @element.appendChild element

  calculateSubscribes:->
    value = getModel true
    return if !value?

ListView.ITEM_VIEW_ATTRIBUTE = 'item-view'

BindIt.View.List = ListView