class DOMEventDispatcher extends BindIt.EventDispatcher
  constructor: (@element) ->
    super()
    BindIt.DOM.addEventHandler @element, 'click', ()=> @callEvent 'click', arguments

  click:(listener)-> @addEventListener 'click', listener

BindIt.DOMEventDispatcher = DOMEventDispatcher
