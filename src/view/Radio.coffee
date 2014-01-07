class RadioView extends BindIt.View
  constructor: (@element) ->
    super @element
    @element.onchange = =>
      @setValue @element.getAttribute RadioView.VALUE_ATTRIBUTE
    @changed()

  changed:->
    viewValue = @getValue false
    value = @element.getAttribute RadioView.VALUE_ATTRIBUTE

    @setElementEnabled viewValue?
    @setElementChecked viewValue == value

  setElementEnabled:(enabled)->
    return @element.removeAttribute 'disabled' if enabled
    @element.setAttribute 'disabled', ''

  setElementChecked:(checked)->
    return @element.setAttribute 'checked', '' if checked
    @element.removeAttribute 'checked'

RadioView.VALUE_ATTRIBUTE = 'value'

BindIt.View.Radio = RadioView
BindIt.View.Input.byType.radio = RadioView