class InputView extends BindIt.View
  constructor: (@element) ->
    type = @element.getAttribute('type')
    return new InputView.byType[type](@element)

InputView.byType = {}

BindIt.View.Input = InputView
BindIt.View.Default.input = InputView