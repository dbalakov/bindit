class CheckboxView extends BindIt.View
  constructor:(element)->
    super element
    @subscribe()
    @changed()

  changed:->
    @setElementValue @getValue() == true
    @setElementEnabled @getValue() == true || @getValue() == false

  subscribe:->
    @element.onchange = =>
      @setValue @getElementValue()

  getElementValue:->
    return @element.checked

  setElementValue:(value)->
    @element.checked = value

  setElementEnabled:(enabled)->
    return @element.removeAttribute 'disabled' if enabled
    @element.setAttribute 'disabled', 'disabled'

BindIt.View.Checkbox = CheckboxView
BindIt.View.Input.byType.checkbox = CheckboxView