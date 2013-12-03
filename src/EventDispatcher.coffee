class EventDispatcher
  constructor: () ->
    @eventHandlers = {}

  addEventListener: (eventType, handler) ->
    @eventHandlers[eventType] = [] if !@eventHandlers[eventType]?
    @eventHandlers[eventType].push handler

  removeEventListener: (eventType, handler) ->
    return if !@eventHandlers[eventType]?
    index = @eventHandlers[eventType].indexOf handler
    return if index < 0
    @eventHandlers[eventType].splice index, 1

  callEvent: (eventType, args) ->
    return if !@eventHandlers[eventType]?
    handler.apply(@, args) for handler in @eventHandlers[eventType]

window.BindIt.EventDispatcher = EventDispatcher