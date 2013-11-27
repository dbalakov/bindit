class InputView extends BindIt.View
  constructor: (@element) ->
    type = @element.getAttribute('type') or 'undefined'
    inputClass = InputView.byType[type.toLowerCase()]
    return new inputClass(@element) if inputClass? && inputClass instanceof Function
    BindIt.Logger.warn "Can't find view class for input tag with type '#{type}'", @element

InputView.byType = {}

BindIt.View.Input = InputView
BindIt.View.Default.input = InputView