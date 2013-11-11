module 'DOMEventDispatcher'

test 'click', ()->
  mock = { click : ()-> }
  expectCall mock, 'click'

  button = document.createElement 'button'
  dispatcher = new BindIt.DOMEventDispatcher button
  dispatcher.click mock.click

  event = document.createEvent('MouseEvents')
  event.initMouseEvent 'click', true, true, window, 0, 1, 2, 3, 4, false, false, true, false, 0, null
  button.dispatchEvent event