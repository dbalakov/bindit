module 'ListView'

test 'Constructor: element without item-view, constructor call logger', ->
  expectLogger 'warn', ()-> createView 'model'

test 'Constructor: element with invalid item-view, constructor call logger', ->
  expectLogger 'warn', ()-> createView 'model', 'ghostItemView'

test 'Constructor: element with null item-view, constructor call logger', ->
  window.ghostItemView = null
  expectLogger 'warn', ()-> createView 'model', 'ghostItemView'

test 'Constructor: create elements', ->
  #expectCall - Error: An attempt was made to reference a Node in a context where it does not exist.
  window.model = new BindIt.Model [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ]
  window.itemView = {
    args: [],
    create:(item)->
      @args.push item
      document.createElement 'div'
  }

  view = createView 'model', 'itemView'
  equal itemView.args.length, 2, 'Constructor call itemView.create'

  equal itemView.args[0], model[0], 'Constructor call itemView.create with valid arguments (first call)'
  equal itemView.args[1], model[1], 'Constructor call itemView.create with valid arguments (second call)'

  equal view.element.childNodes.length, 2, 'Constructor append elements'

test 'Model changed, view changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView = { create:(item)-> document.createElement 'div' }
  view = createView 'model:array', 'itemView'

  model.array = []
  equal view.element.childNodes.length, 0, 'Model changed, view changed'

test 'Element changed, call itemView changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView = { create:(item)-> document.createElement 'div', changed:-> }
  view = createView 'model:array', 'itemView'

  expectCall(itemView, 'changed').with model.array[0], view.element.childNodes[0]
  expectCall(view, 'apocalyptic').calls(0)
  model.array[1].name = 'Edgar Allan Poe'

createView = (model, itemView)->
  element = document.createElement 'div'
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, model if model?
  element.setAttribute BindIt.View.List.ITEM_VIEW_ATTRIBUTE, itemView if itemView?
  new BindIt.View.List element

expectLogger = (method, test)->
  logger = BindIt.Logger
  BindIt.Logger = {}
  BindIt.Logger[method] = ()->
  expectCall BindIt.Logger, method
  test()
  BindIt.Logger = logger