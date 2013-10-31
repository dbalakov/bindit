module 'ModelArray'

test 'Constructor', ->
  model = new BindIt.Model [ 42 ]
  ok model.hasOwnProperty(0), 'Constructor define properties'

test 'Getters', ->
  source = [ 42, {}, [ 1, 42 ], 'string' ]
  model = new BindIt.Model source

  equal model[0], 42, 'Getter return valid number value'
  equal model[1], new BindIt.Model(source[1]), 'Getter return valid object value'
  equal model[2], new BindIt.Model(source[2]), 'Getter return valid array value'
  equal model[3], 'string', 'Getter return valid string value'

test 'Setter', ->
  source = [ 42, {}, [ 1, 42 ], 'string' ]
  newLink = {}
  newArray = [ 13, 666 ]

  model = new BindIt.Model source
  model[0] = 24
  model[1] = new BindIt.Model newLink
  model[2] = newArray
  model[3] = 'new string'

  equal source[0], 24, 'Setter change value in source (Number)'
  equal source[1], newLink, 'Setter change value in source (Object)'
  equal source[2], newArray, 'Setter change value in source (Array)'
  equal source[3], 'new string', 'Setter change value in source (String)'

  newAnswer = {}
  mock = handler : (->)
  expectCall(mock, 'handler').with model, 0, 24, new BindIt.Model newAnswer

  model.addEventListener BindIt.Model.Events.VALUE_CHANGED, mock.handler
  model[0] = newAnswer

test 'length', ->
  model = new BindIt.Model []
  model.length = 20

  ok model.hasOwnProperty(19), 'Define properties, after increment length'

test 'push', ->
  item = {}
  model = new BindIt.Model []
  mock = handler : (->)
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.INSERTED, 0, new BindIt.Model item
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.push item

  deepEqual model.getSource(), [ item ], 'Source has valid elements after pushing'
  equal result, 1, 'Push returns valid value'
  ok model.hasOwnProperty(0), 'Define properties, after pushing'

test 'pop', ->
  item = {}
  model = new BindIt.Model [ 1, item ]
  mock = handler : ( ()-> @args = arguments )
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.REMOVED, 1, new BindIt.Model item
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.pop()

  deepEqual model.getSource(), [ 1 ], 'Source has valid elements after popping'
  equal result, new BindIt.Model item, 'Pop returns valid value'

test 'concat', ->
  model = new BindIt.Model [ 1, 42 ]

  result = model.concat [ 2, 13 ]
  deepEqual result.getSource(), [ 1, 42, 2, 13 ], 'Concat return valid value'

test 'join', ->
  equal (new BindIt.Model [ 1, 42 ]).join(';'), '1;42', 'Join return valid value'

test 'reverse', ->
  item = {}
  model = new BindIt.Model [ 1, item ]
  mock = handler : (->)
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.APOCALYPTIC
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.reverse()

  deepEqual model.getSource(), [ item, 1 ], 'Source has valid elements after reversing'
  equal result, model, 'Reverse returns valid value'

test 'shift', ->
  item = {}
  model = new BindIt.Model [ item, 1 ]
  mock = handler : (->)
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.REMOVED, 0, new BindIt.Model item
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.shift()

  deepEqual model.getSource(), [ 1 ], 'Source has valid elements after shifting'
  equal result, new BindIt.Model(item), 'Shift returns valid value'

test 'slice', ->
  deepEqual (new BindIt.Model [ 1, 42, 18, 6, 7, 18 ]).slice(1, 4).getSource(), [ 42, 18, 6 ], 'slice return valid value'

test 'sort', ->
  model = new BindIt.Model [ 42, 13, 50, 10 ]
  mock = handler : (->)
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.APOCALYPTIC
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.sort()

  deepEqual model.getSource(), [ 10, 13, 42, 50 ], 'Source has valid elements after sorting'
  equal result, model, 'Sort returns valid value'

test 'splice', ->
  model = new BindIt.Model [ 42, 13, 50, 10 ]
  mock = handler : (->)
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.APOCALYPTIC
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.splice(0, 2)

  deepEqual model.getSource(), [ 50, 10 ], 'Source has valid elements after splicing'
  deepEqual result.getSource(), [ 42, 13 ], 'Splice returns valid value'

test 'unshift', ->
  item = {}
  model = new BindIt.Model [ 1 ]
  mock = handler : (->)
  expectCall(mock, 'handler').with model, BindIt.Model.ArrayEvents.INSERTED, 0, new BindIt.Model item
  model.addEventListener BindIt.Model.Events.ARRAY_CHANGED, mock.handler

  result = model.unshift item

  deepEqual model.getSource(), [ item, 1 ], 'Source has valid elements after unshift'
  equal result, 2, 'unshift returns valid value'

test 'indexOf', ->
  item = {}
  model = new BindIt.Model [ 42, item ]

  equal model.indexOf(42), 0, 'indexOf returns valid value (Number)'
  equal model.indexOf(new BindIt.Model(item)), 1, 'indexOf returns valid value (Model)'