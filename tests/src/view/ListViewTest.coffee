module 'ListView'

test 'Constructor: element without item-view, constructor call logger', ->
  expectLogger 'warn', ()-> createListView 'model'

test 'Constructor: element with invalid item-view, constructor call logger', ->
  expectLogger 'warn', ()-> createListView 'model', 'ghostItemView'

test 'Constructor: element with null item-view, constructor call logger', ->
  window.ghostItemView = null
  expectLogger 'warn', ()-> createListView 'model', 'ghostItemView'

test 'Constructor: create elements', ->
  window.model = new BindIt.Model [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ]
  window.itemView = {
    args: [],

    create:->
      @args.push arguments
      document.createElement 'div'
  }

  view = createListView 'model', 'itemView'
  equal itemView.args.length, 2, 'Constructor call itemView.create'

  deepEqual itemView.args[0], { 0 : model, 1 : 0, 2 : true, 3 : false }, 'Constructor call itemView.create with valid arguments (first call)'
  deepEqual itemView.args[1], { 0 : model, 1 : 1, 2 : false, 3 : false }, 'Constructor call itemView.create with valid arguments (second call)'

  equal view.element.childNodes.length, 2, 'Constructor append elements'

test 'Constructor: state', ->
  window.model = new BindIt.Model [ { name : 'Edgar Poe', state : {} }, { name : 'Howard Lovecraft' } ]
  window.itemView =
    elements : {}

    create : (model, index)->
      element = document.createElement 'div'
      @elements[index] = element
      element

  view = createListView 'model', 'itemView'
  equal view.itemsSubscribes.length, 3, 'See valid itemsSubscribes'

  #itemsSubscribes
  equal view.itemsSubscribes.get(model[0]), model[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model[0].state), model[0], 'See valid itemsSubscribes subobject (Poe)'
  equal view.itemsSubscribes.get(model[1]), model[1], 'See valid itemsSubscribes (Lovecraft)'

  #itemsElements
  equal view.itemsElements.length, 2, 'See valid itemsElements length'
  equal view.itemsElements[0], itemView.elements[0], 'See valid itemsElements (Poe)'
  equal view.itemsElements[1], itemView.elements[1], 'See valid itemsElements (Lovecraft)'

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
    elements : {}

    create:(model, index)->
      element = document.createElement 'div'
      @elements[index] = element
      element

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'

  expectCall(itemView, 'changed').with view.element.childNodes[0], model.array, 0, true, false
  expectCall(view, 'apocalyptic').calls(0)

  model.array[0].name = 'Edgar Allan Poe'

  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[1]), model.array[1], 'See valid itemsSubscribes (Lovecraft)'

  equal view.itemsElements[0], itemView.elements[0], 'See valid itemsElements (Poe)'
  equal view.itemsElements[1], itemView.elements[1], 'See valid itemsElements (Lovecraft)'

test 'Array element changed, call itemView changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : {}

    create:(model, index)->
      element = document.createElement 'div'
      @elements[index] = element
      element

    changed:->

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(itemView, 'changed').with view.element.childNodes[0], model.array, 0, true, false
  expectCall view, 'apocalyptic', 0

  model.array[0] = newValue

  equal view.itemsSubscribes.length, 2, 'See valid itemsSubscribes'
  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[1]), model.array[1], 'See valid itemsSubscribes (Lovecraft)'

  equal view.itemsElements.length, 2, 'See valid itemsElements'
  equal view.itemsElements[0], itemView.elements[0], 'See valid itemsElements (Poe)'
  equal view.itemsElements[1], itemView.elements[1], 'See valid itemsElements (Lovecraft)'

test 'Array: element pushed, call create', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : {}
    args: []

    create:(model, index)->
      @args.push index
      element = document.createElement 'div'
      @elements[index] = element
      element

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(view, 'apocalyptic').calls 0

  model.array.push newValue

  equal view.element.childNodes.length, 3, 'New element was appended'
  equal itemView.args.length, 3, 'Create called'
  equal itemView.args[2], 2, 'Create called with valid arguments'

  equal view.itemsSubscribes.length, 3, 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[0]), model.array[0], 'See valid itemsSubscribes (Poe)'
  equal view.itemsSubscribes.get(model.array[1]), model.array[1], 'See valid itemsSubscribes (Lovecraft)'
  equal view.itemsSubscribes.get(model.array[2]), model.array[2], 'See valid itemsSubscribes (new value)'

  equal view.itemsElements.length, 3, 'See valid itemsElements'
  equal view.itemsElements[0], itemView.elements[0], 'See valid itemsElements (Poe)'
  equal view.itemsElements[1], itemView.elements[1], 'See valid itemsElements (Lovecraft)'
  equal view.itemsElements[2], itemView.elements[2], 'See valid itemsElements (new object)'

test 'Array: element inserted, call create', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args: [],

    create:(model, index)->
      @args.push index
      element = document.createElement 'div'
      element.index = model[index]
      element

    changed:->
      @args = arguments

  view = createListView 'model:array', 'itemView'
  newValue = new BindIt.Model {}

  expectCall(view, 'apocalyptic').calls 0

  model.array.unshift newValue

  equal view.element.childNodes.length, 3, 'New element was inserted'
  equal view.element.childNodes[0].index, model.array[0], 'New element was inserted with valid index'
  equal itemView.args.length, 3, 'Create called'
  equal itemView.args[2], 0, 'Create called with valid arguments'
  #TODO After insert must call changed for all elements (index changed)

test 'Array: element removed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements : new BindIt.Hash
    args: []

    create:(model, index)->
      element = document.createElement 'div'
      element.item = model[index]
      @elements.add model[index], element
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
  equal view.itemsElements[0], itemView.elements.get(model.array[0]), 'See valid itemsElements value'
  #TODO After remove must call changed for all elements (index changed)

test 'Array: length incremented', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    args : []

    create:(model, index)->
      element = document.createElement 'div'
      element.item = model[index]
      @args.push arguments
      element

    changed:(->)

  view = createListView 'model:array', 'itemView'
  itemView.args = []

  expectCall(view, 'apocalyptic').calls 0
  model.array.length = 5

  equal itemView.args.length, 3, 'Create was called'
  equal view.element.childNodes.length, 5, 'Element was append'
  deepEqual itemView.args[0], { 0 : model.array, 1 : 2, 2 : false, 3 : false }, 'Create was called with valid arguments'

  equal view.itemsSubscribes.length, 2, 'See valid itemsSubscribes'
  equal view.itemsElements.length, 5, 'See valid itemsElements'

test 'Array: length decrement', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    create: -> document.createElement 'div'
    changed:(->)

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'create').calls 0
  model.array.length = 1

  equal view.element.childNodes.length, 1, 'Element was removed'
  equal view.itemsSubscribes.length, 1, 'See valid itemsSubscribes'
  equal view.itemsElements.length, 1, 'See valid itemsElements'

test 'Array: selectedItem changed', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' } ] }
  window.itemView =
    elements: []
    args: []

    create: ->
      element = document.createElement 'div'
      @elements.push element
      element

    changed:-> @args.push arguments

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'create').calls 0
  expectCall(itemView, 'changed').calls 2

  model.array.selectedItem = 1

  deepEqual itemView.args[0], { 0: itemView.elements[0], 1 : model.array, 2 : 0, 3 : false, 4 : false}, 'Call changed to old selected item'
  deepEqual itemView.args[1], { 0: itemView.elements[1], 1 : model.array, 2 : 1, 3 : true, 4 : false}, 'Call changed to new selected item'

test 'Array: selectedItems changed (field)', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' }, { name : 'William Gibson' } ] }
  model.array.selectedItems.push 0
  window.itemView =
    elements: []
    args: []

    create: ->
      element = document.createElement 'div'
      @elements.push element
      element

    changed:-> @args.push arguments

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'changed').calls 2

  model.array.selectedItems = [ 1 ]
  deepEqual itemView.args[0], { 0: itemView.elements[0], 1 : model.array, 2 : 0, 3 : true, 4 : false }, 'Call changed to old selected item with valid arguments'
  deepEqual itemView.args[1], { 0: itemView.elements[1], 1 : model.array, 2 : 1, 3 : false, 4 : true }, 'Call changed to new selected item with valid arguments'

test 'Array: selectedItems changed (insert value)', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' }, { name : 'William Gibson' } ] }
  window.itemView =
    elements: []
    args: []

    create: ->
      element = document.createElement 'div'
      @elements.push element
      element

    changed:-> @args.push arguments

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'changed').calls 1

  model.array.selectedItems.push 1
  deepEqual itemView.args[0], { 0: itemView.elements[1], 1 : model.array, 2 : 1, 3 : false, 4 : true }, 'Call changed with valid arguments'

test 'Array: selectedItems changed (remove value)', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' }, { name : 'William Gibson' } ] }
  window.model.array.selectedItems.push 1
  window.itemView =
    elements: []
    args: []

    create: ->
      element = document.createElement 'div'
      @elements.push element
      element

    changed:-> @args.push arguments

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'changed').calls 1

  model.array.selectedItems.shift()
  deepEqual itemView.args[0], { 0: itemView.elements[1], 1 : model.array, 2 : 1, 3 : false, 4 : false }, 'Call changed with valid arguments'

test 'Array: selectedItems changed (field)', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' }, { name : 'William Gibson' } ] }
  window.model.array.selectedItems.push 1
  window.itemView =
    elements: []
    args: []

    create: ->
      element = document.createElement 'div'
      @elements.push element
      element

    changed:-> @args.push arguments

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 0
  expectCall(itemView, 'changed').calls 2

  model.array.selectedItems[0] = 0
  deepEqual itemView.args[0], { 0: itemView.elements[1], 1 : model.array, 2 : 1, 3 : false, 4 : false }, 'Call changed with valid arguments (old value)'
  deepEqual itemView.args[1], { 0: itemView.elements[0], 1 : model.array, 2 : 0, 3 : true, 4 : true }, 'Call changed with valid arguments (new value)'

test 'Array: selectedItems changed (apocalyptic changes)', ->
  window.model = new BindIt.Model { array : [ { name : 'Edgar Poe' }, { name : 'Howard Lovecraft' }, { name : 'William Gibson' } ] }
  window.model.array.selectedItems.push 1
  window.itemView =
    create: -> document.createElement 'div'
    changed:(->)

  view = createListView 'model:array', 'itemView'

  expectCall(view, 'apocalyptic').calls 1

  model.array.selectedItems.sort()

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