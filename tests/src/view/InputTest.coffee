module 'Input'

class InputTest extends BindIt.View

test 'Constructor', ()->
  BindIt.View.Input.byType.test = InputTest

  ok createInputView('test') instanceof InputTest, 'Constructor return valid view from byType'

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('input')), BindIt.View.Input, 'Default view for input tag is InputView'

createInput = (type)->
  result = document.createElement 'input'
  result.setAttribute 'type', type
  result

createInputView = (type)->
  new BindIt.View.Input createInput(type)