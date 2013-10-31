module 'Model'

test 'Constructor return valid Model', ->
  source = {}
  model = new BindIt.Model source

  equal model, new BindIt.Model(model), 'If source instance of Model, constructor return source'
  equal model, new BindIt.Model(source), 'If model for this source was created earlier, constructor returns this model'

test 'getSource', ->
  source = {}
  model = new BindIt.Model source

  equal model.getSource(), source, 'getSource return valid source (Model)'

test 'Getters', ->
  source = { answer : 42, link : {}, array : [ 1, 42 ], string : 'string' }
  model = new BindIt.Model source

  equal model.answer, 42, 'Getter return valid number value'
  equal model.link, new BindIt.Model(source.link), 'Getter return valid object value'
  equal model.array, new BindIt.Model(source.array), 'Getter return valid array value'
  equal model.string, 'string', 'Getter return valid string value'

test 'Setter', ->
  source = { answer : 42, link : {}, array : [ 1, 42 ], string : 'string' }
  newLink = {}
  newArray = [ 13, 666 ]

  model = new BindIt.Model source
  model.answer = 24
  model.link = new BindIt.Model newLink
  model.array = newArray
  model.string = "new string"

  equal source.answer, 24, 'Setter change value in source (Number)'
  equal source.link, newLink, 'Setter change value in source (Object)'
  equal source.array, newArray, 'Setter change value in source (Array)'
  equal source.string, 'new string', 'Setter change value in source (String)'

  newAnswer = {}
  mock = handler : (->)
  expectCall(mock, 'handler').with model, 'answer', 24, new BindIt.Model newAnswer

  model.addEventListener BindIt.Model.Events.VALUE_CHANGED, mock.handler
  model.answer = newAnswer

test 'Functions', ->
  calledObject = null
  source = { func : () -> calledObject = @ }
  model = new BindIt.Model source
  model.func()

  equal calledObject, model, 'Function was called with valid context'