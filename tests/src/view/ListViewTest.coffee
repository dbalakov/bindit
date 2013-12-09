#TODO Написать тесты на внутреннее состояние (@itemsSubscribes & @itemsElements)
module 'ListView'

test 'Constructor: element without item-view, constructor call logger', ->
  expectLogger 'warn', ()-> createListView 'model'

test 'Constructor: element with invalid item-view, constructor call logger', ->
  expectLogger 'warn', ()-> createListView 'model', 'ghostItemView'

test 'Constructor: element with null item-view, constructor call logger', ->
  window.ghostItemView = null
  expectLogger 'warn', ()-> createListView 'model', 'ghostItemView'

test 'Constructor: create elements', ->
  #expectCall - Error: An attempt was made to reference a Node in a context where it does not exist.
  window.model = new BindIt.Model [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ]
  window.itemView = {
    args: [],

    create:(item)->
      @args.push item
      document.createElement 'div'
  }

  view = createListView 'model', 'itemView'
  equal itemView.args.length, 2, 'Constructor call itemView.create'

  equal itemView.args[0], model[0], 'Constructor call itemView.create with valid arguments (first call)'
  equal itemView.args[1], model[1], 'Constructor call itemView.create with valid arguments (second call)'

  equal view.element.childNodes.length, 2, 'Constructor append elements'

test 'Model changed, view changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView = { create:(item)-> document.createElement 'div' }
  view = createListView 'model:array', 'itemView'

  model.array = []
  equal view.element.childNodes.length, 0, 'Model changed, view changed'

test 'Element changed, call itemView changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    create:(item)->
      document.createElement('div')

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'

  expectCall(itemView, 'changed').with model.array[0], view.element.childNodes[0]
  expectCall(view, 'apocalyptic').calls(0)

  model.array[0].name = 'Edgar Allan Poe'

test 'Array element changed, call itemView changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    create:->
      document.createElement('div')

    changed:->

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(itemView, 'changed').with newValue, view.element.childNodes[0]
  expectCall view, 'apocalyptic', 0

  model.array[0] = newValue

test 'Array: element pushed, call create', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args: [],

    create:(item)->
      @args.push item
      result = document.createElement 'div'
      result

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(view, 'apocalyptic').calls 0

  model.array.push newValue

  equal view.element.childNodes.length, 3, 'New element was appended'
  equal itemView.args.length, 3, 'Create called'
  equal itemView.args[2], newValue, 'Create called with valid arguments'

test 'Array: element inserted, call create', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args: [],

    create:(item)->
      @args.push item
      element = document.createElement 'div'
      element.item = item
      element

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(view, 'apocalyptic').calls 0

  model.array.unshift newValue

  equal view.element.childNodes.length, 3, 'New element was inserted'
  equal view.element.childNodes[0].item, newValue, 'New element was inserted with valid index'
  equal itemView.args.length, 3, 'Create called'
  equal itemView.args[2], newValue, 'Create called with valid arguments'

test 'Array: element removed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args: [],

    create:(item)->
      element = document.createElement 'div'
      element.item = item
      element

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'
  expectCall(view, 'apocalyptic').calls 0

  model.array.shift()

  equal view.element.childNodes.length, 1, 'Element was removed'
  equal view.element.childNodes[0].item, model.array[0], 'Valid element was removed'

createListView = (model, itemView)->
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