class TextView extends BindIt.View
  constructor: (@element)->
    super @element
    @changed()

    @element.onchange = @elementListener
    @element.onkeyup  = @elementListener
    @element.onpaste  = @elementListener

  changed: ->
    @setEnabled()
    @setElementValue @getValue()

  setEnabled: ->
    return @element.removeAttribute 'disabled' if @getValue()?
    @element.setAttribute 'disabled', 'disabled'

  setElementValue: (value)->
    value = value or ''
    @element.value = value if @element.value != value

  elementListener:=>
    @setValue(@element.value) if @element.value != @getValue()

BindIt.View.Text = TextView
BindIt.View.Default.textarea = TextView
BindIt.View.Input.byType.text = TextView
BindIt.View.Input.byType.password = TextView