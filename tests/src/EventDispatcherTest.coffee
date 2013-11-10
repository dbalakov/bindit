module 'EventDispatcher'

test 'Handler was called', ->
  mock = handler : ->
  expectCall mock, 'handler'

  eventDispatcher = new BindIt.EventDispatcher
  eventDispatcher.addEventListener 'event', mock.handler
  eventDispatcher.callEvent 'event'

test 'All handlers was called', ->
  mock = { handler : (->), anotherHandler: (->) }
  expectCall mock, 'handler'
  expectCall mock, 'anotherHandler'

  eventDispatcher = new BindIt.EventDispatcher
  eventDispatcher.addEventListener 'event', mock.handler
  eventDispatcher.addEventListener 'event', mock.anotherHandler
  eventDispatcher.callEvent 'event'

test 'After remove handler, it not called', ->
  mock = handler : ->
  expectCall(mock, 'handler').calls 0

  eventDispatcher = new BindIt.EventDispatcher
  eventDispatcher.addEventListener 'event', mock.handler
  eventDispatcher.removeEventListener 'event', mock.handler
  eventDispatcher.callEvent 'event'

test 'Handler was called with valid arguments', ->
  mock = handler : ->
  expectCall(mock, 'handler').with 1, 42

  eventDispatcher = new BindIt.EventDispatcher
  eventDispatcher.addEventListener 'event', mock.handler
  eventDispatcher.callEvent 'event', [ 1, 42 ]

