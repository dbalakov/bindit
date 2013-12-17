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

    create:->
      @args.push arguments
      document.createElement 'div'
  }

  view = createListView 'model', 'itemView'
  equal itemView.args.length, 2, 'Constructor call itemView.create'

  deepEqual itemView.args[0], { 0 : model, 1 : model[0] }, 'Constructor call itemView.create with valid arguments (first call)'
  deepEqual itemView.args[1], { 0 : model, 1 : model[1] }, 'Constructor call itemView.create with valid arguments (second call)'

  equal view.element.childNodes.length, 2, 'Constructor append elements'

test 'Constructor: state', ->
  window.model = new BindIt.Model [ { name : 'Edgar Poe', state : {} }, { name : 'Howard Lovecraft' } ]
  window.itemView =
    elements : new BindIt.Hash

    create : (model, item)->
      element = document.createElement 'div'
      @elements.add item, element
      element

  view = createListView 'model', 'itemView'
  equal view.itemsSubscribes.length, 3, 'See valid itemsSubscribes'

  #itemsSubscribes
  equal view.itemsSubscribes.get(model[0]), model[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model[0].state), model[0], 'See valid itemsSubscribes subobject (Poe)'
  equal view.itemsSubscribes.get(model[1]), model[1], 'See valid itemsSubscribes (Lovecraft)'

  #itemsElements
  equal view.itemsElements.get(model[0]), itemView.elements.get(model[0]), 'See valid itemsElements (Poe)'
  equal view.itemsElements.get(model[1]), itemView.elements.get(model[1]), 'See valid itemsElements (Lovecraft)'

test 'Model changed, view changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : new BindIt.Hash

    create : (item)->
      element = document.createElement 'div'
      @elements.add item, element
      element

  view = createListView 'model:array', 'itemView'

  model.array = []

  equal view.element.childNodes.length, 0, 'Model changed, view changed'
  equal view.itemsSubscribes.length, 0, 'See valid itemsSubscribes'
  equal view.itemsElements.length, 0, 'See valid itemsElements'

test 'Element changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : new BindIt.Hash

    create:(model, item)->
      element = document.createElement 'div'
      @elements.add item, element
      element

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'

  expectCall(itemView, 'changed').with model.array[0], view.element.childNodes[0]
  expectCall(view, 'apocalyptic').calls(0)

  model.array[0].name = 'Edgar Allan Poe'

  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[1]), model.array[1], 'See valid itemsSubscribes (Lovecraft)'

  equal view.itemsElements.get(model.array[0]), itemView.elements.get(model.array[0]), 'See valid itemsElements (Poe)'
  equal view.itemsElements.get(model.array[1]), itemView.elements.get(model.array[1]), 'See valid itemsElements (Lovecraft)'


test 'Array element changed, call itemView changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : new BindIt.Hash

    create:(model, item)->
      element = document.createElement 'div'
      @elements.add item, element
      element

    changed:->

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(itemView, 'changed').with newValue, view.element.childNodes[0]
  expectCall view, 'apocalyptic', 0

  model.array[0] = newValue

  equal view.itemsSubscribes.length, 2, 'See valid itemsSubscribes'
  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[1]), model.array[1], 'See valid itemsSubscribes (Lovecraft)'

  equal view.itemsElements.length, 2, 'See valid itemsElements'
  equal view.itemsElements.get(model.array[0]), itemView.elements.get(model.array[0]), 'See valid itemsElements (Poe)'
  equal view.itemsElements.get(model.array[1]), itemView.elements.get(model.array[1]), 'See valid itemsElements (Lovecraft)'

test 'Array: element pushed, call create', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : new BindIt.Hash
    args: []

    create:(model, item)->
      @args.push item
      element = document.createElement 'div'
      @elements.add item, element
      element

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(view, 'apocalyptic').calls 0

  model.array.push newValue

  equal view.element.childNodes.length, 3, 'New element was appended'
  equal itemView.args.length, 3, 'Create called'
  equal itemView.args[2], newValue, 'Create called with valid arguments'

  equal view.itemsSubscribes.length, 3, 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[1]), model.array[1], 'See valid itemsSubscribes (Lovecraft)'
  equal view.itemsSubscribes.get(model.array[2]), model.array[2], 'See valid itemsSubscribes (new value)'

  equal view.itemsElements.length, 3, 'See valid itemsElements (Poe)'
  equal view.itemsElements.get(model.array[0]), itemView.elements.get(model.array[0]), 'See valid itemsElements (Poe)'
  equal view.itemsElements.get(model.array[1]), itemView.elements.get(model.array[1]), 'See valid itemsElements (Lovecraft)'
  equal view.itemsElements.get(model.array[2]), itemView.elements.get(model.array[2]), 'See valid itemsElements (Lovecraft)'

test 'Array: element inserted, call create', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args: [],

    create:(model, item)->
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
    elements : new BindIt.Hash
    args: []

    create:(model, item)->
      element = document.createElement 'div'
      element.item = item
      @elements.add item, element
      element

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'
  expectCall(view, 'apocalyptic').calls 0

  model.array.shift()

  equal view.element.childNodes.length, 1, 'Element was removed'
  equal view.element.childNodes[0].item, model.array[0], 'Valid element was removed'

  equal view.itemsSubscribes.length, 1, 'See valid itemsSubscribes'
  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes value'

  equal view.itemsElements.length, 1, 'See valid itemsElements'
  equal view.itemsElements.get(model.array[0]), itemView.elements.get(model.array[0]), 'See valid itemsElements value'

test 'Array: length incremented', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args : []

    create:(model, item)->
      element = document.createElement 'div'
      element.item = item
      @args.push arguments
      element

    changed:(->)

  view = createListView 'model:array', 'itemView'
  itemView.args = []

  expectCall(view, 'apocalyptic').calls 0
  model.array.length = 5

  equal itemView.args.length, 3, 'Create was called'
  equal view.element.childNodes.length, 5, 'Element was append'
  deepEqual itemView.args[0], { 0 : model.array, 1 : model.array[2] }, 'Create was called with valid arguments'

  equal view.itemsSubscribes.length, 2, 'See valid itemsSubscribes'
  equal view.itemsElements.length, 2, 'See valid itemsElements'

test 'Array: length decrement', -> #TODO itemsSubscribes, itemsElements
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    create: -> document.createElement 'div'
    changed:(->)

  view = createListView 'model:array', 'itemView'
  itemView.args = []

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'create').calls 0
  model.array.length = 1

  equal view.element.childNodes.length, 1, 'Element was removed'
  equal view.itemsSubscribes.length, 1, 'See valid itemsSubscribes'
  equal view.itemsElements.length, 1, 'See valid itemsElements'

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

#length
#selectedItem
#selectedItems