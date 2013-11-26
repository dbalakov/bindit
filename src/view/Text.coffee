class TextView extends BindIt.View
  constructor: (@element)->
    super @element
    @changed()

    @element.onchange = @elementListener
    @element.onkeyup  = @elementListener
    @element.onpaste  = @elementListener

  changed: ->
    @setEnabled()
    @setElementValue @getModel()

  setEnabled: ->
    return @element.removeAttribute 'disabled' if @getModel()?
    @element.setAttribute 'disabled', 'disabled'

  setElementValue: (value)->
    value = value or ''
    @element.value = value if @element.value != value

  elementListener:=>
    @setValue(@element.value) if @element.value != @getModel()

BindIt.View.Text = TextView
BindIt.View.Default.textarea = TextView
BindIt.View.Input.byType.text = TextView