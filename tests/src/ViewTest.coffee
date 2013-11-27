module 'View'

test 'Constructor', ->
  #Element should have only one view
  throws (->
    element = createDivWithDataBindAttribute ''
    new BindIt.View element
    new BindIt.View element), 'Element should have only one view'

  #Constructor call refreshSubscribes
  window.model = new BindIt.Model { array : [ { name : { firstName : '!!!', lastName : '222' } } ] }
  view = new BindIt.View createDivWithDataBindAttribute 'model:array:name'
  deepEqual view.subscribes, [ model, model.array, model.array[0], model.array[0].name ], 'Constructor call refreshSubscribes'

test 'refreshSubscribes', ->
  window.model = new BindIt.Model { array : [ {}, {} ] }
  view = new BindIt.View createDivWithDataBindAttribute 'model:array'
  deepEqual view.subscribes, [ model, model.array, model.array[0], model.array[1] ], 'refreshSubscribes set valid subscribes (model is array)'

  window.model = new BindIt.Model { sex : 'male', name : { firstName : 'Edgar', lastName : 'Poe' } }
  view = new BindIt.View createDivWithDataBindAttribute 'model'
  deepEqual view.subscribes, [ model, model.name ], 'refreshSubscribes set valid subscribes (with properties of model)'

test 'refreshSubscribes:view call changed when model changed', ->
  window.model = new BindIt.Model { status : 'poet', name : { firstName : 'Edgar', lastName : 'Poe' } }
  view = new BindIt.View createDivWithDataBindAttribute 'model'
  view.changed = ->
  expectCall(view, 'changed').with view, model, BindIt.Model.Events.VALUE_CHANGED, 'status', 'poet', 'genius'
  model.status = 'genius'

test 'refreshSubscribes:view call changed when model property changed', ->
  window.model = new BindIt.Model { sex : 'male', name : { firstName : 'Edar', lastName : 'Poe' } }
  view = new BindIt.View createDivWithDataBindAttribute 'model'
  view.changed = ->
  expectCall(view, 'changed').with view, model.name, BindIt.Model.Events.VALUE_CHANGED, 'firstName', 'Edar', 'Edgar'
  model.name.firstName = 'Edgar'

test 'refreshSubscribes:view call changed when model array property changed', ->
  window.model = new BindIt.Model { name : 'Edgar Poe', poems : [ 'Raven' ] }
  view = new BindIt.View createDivWithDataBindAttribute 'model'
  view.changed = ->
  expectCall(view, 'changed').with view, model.poems, BindIt.Model.Events.VALUE_CHANGED, 'length', 1, 2
  model.poems.length = 2

test 'refreshSubscribes:view call changed when model array changed', ->
  window.model = new BindIt.Model { name : 'Edgar Poe', poems : [ 'Raven' ] }
  view = new BindIt.View createDivWithDataBindAttribute 'model'
  view.changed = ->
  expectCall(view, 'changed').with view, model.poems, BindIt.Model.Events.ARRAY_CHANGED, BindIt.Model.ArrayEvents.INSERTED, 1, 'Annabel Lee'
  model.poems.push 'Annabel Lee'

test "refreshSubscribes:Ex don't matter", ->
  window.model = new BindIt.Model { name : 'Edgar Poe', poems : [ 'Raven' ] }
  exPoems = model.poems
  view = new BindIt.View createDivWithDataBindAttribute 'model'
  model.poems = [ 'Raven', 'Annabel Lee' ]
  view.changed = ->
  expectCall(view, 'changed').calls 0
  exPoems.push 'Annabel Lee'
  exPoems.length = 3

test 'getModelPath', ->
  view = new BindIt.View createDivWithDataBindAttribute 'data:property:another_property'
  deepEqual view.getModelPath(), [ 'data', 'property', 'another_property' ], 'getModelPath returns valid path'

  parent = createDivWithFormBindAttribute 'model'
  child = createDivWithDataBindAttribute 'property'
  parent.appendChild child

  view = new BindIt.View child
  deepEqual view.getModelPath(), [ 'model', 'property' ], 'getModelPath returns valid path with form-bind'

test 'getModelPath (dynamical)', ->
  class ViewTest extends BindIt.View
    constructor: (element)->
      super element
      @path = @getModelPath()

  window.ViewTest = ViewTest

  parent = createDivWithFormBindAttribute 'model'
  document.getElementById('trash').appendChild parent
  child = createDivWithDataBindAttribute 'property'
  child.setAttribute BindIt.VIEW_ATTRIBUTE, 'ViewTest'
  parent.appendChild child

  deepEqual child.__bindit_view.path, [ 'model', 'property' ], 'getModelPath returns valid path with form-bind (dynamical add)'

test 'getModel', ->
  window.modelArray = new BindIt.Model []
  equal (new BindIt.View createDivWithDataBindAttribute 'window.Boolean').getModel(false), window.Boolean, 'getModel returns valid value'
  equal (new BindIt.View createDivWithDataBindAttribute 'window.modelArray').getModel(false), null, 'getModel returns valid value (array, returnArray-false)'
  equal (new BindIt.View createDivWithDataBindAttribute 'window.modelArray').getModel(true), window.modelArray, 'getModel returns valid value (array, returnArray-true)'
  equal (new BindIt.View createDivWithDataBindAttribute 'asdasasd:12313:1211').getModel(false), null, 'getModel returns null for unknown variable'

test 'setValue', ->
  window.model = new BindIt.Model { text : 'text', array: [ { item : 1 } ] }
  window.anotherModel = new BindIt.Model {}

  (new BindIt.View(createDivWithDataBindAttribute('model:text'))).setValue('text2')
  (new BindIt.View(createDivWithDataBindAttribute('anotherModel'))).setValue('anotherModel')
  (new BindIt.View(createDivWithDataBindAttribute('model:array:item'))).setValue(42)

  equal window.model.text, 'text2', 'setValue change model'
  equal window.anotherModel, 'anotherModel', 'setValue change model (model path length=1)'
  equal window.model.array[0].item, 42, 'setValue change model in array'

test 'callBindFunction', ->
  window.model = new BindIt.Model { func : ()-> }
  expectCall(window.model, 'func').with 'arg', 0, 42

  view = new BindIt.View createDivWithDataBindAttribute 'model:func'
  view.callBindFunction 'arg', 0, 42

createDivWithFormBindAttribute = (formBind)->
  result = document.createElement 'div'
  result.setAttribute BindIt.FORM_BIND_ATTRIBUTE, formBind
  result

createDivWithDataBindAttribute = (dataBind)->
  result = document.createElement 'div'
  result.setAttribute BindIt.DATA_BIND_ATTRIBUTE, dataBind
  result