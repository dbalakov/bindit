module 'Input'

class InputTest extends BindIt.View

test 'Constructor', ()->
  BindIt.View.Input.byType.test = InputTest

  ok createInputView('test') instanceof InputTest, 'Constructor returns valid view from byType'
  ok createInputView('button') instanceof BindIt.View.Button, 'Constructor returns valid view for type "button"'

  logger = BindIt.Logger
  BindIt.Logger = { warn : -> }
  expectCall(BindIt.Logger, 'warn')
  createInputView 'none'
  BindIt.Logger = logger

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('input')), BindIt.View.Input, 'Default view for input tag is InputView'

createInput = (type)->
  result = document.createElement 'input'
  result.setAttribute 'type', type
  result

createInputView = (type)->
  new BindIt.View.Input createInput(type)