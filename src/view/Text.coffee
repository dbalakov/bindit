class TextView extends BindIt.View
  constructor: (@element)->
    super @element
    @changed()

    @calculateEvent 'enter'
    @calculateEvent 'esc'

    @element.onchange = @elementListener
    @element.onkeyup  = @keyup
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

  keyup:(event)=>
    @elementListener()

    @enter?(event) if event.keyCode == 13
    @esc?(event) if event.keyCode == 27

  elementListener:=>
    @setValue(@element.value) if @element.value != @getValue()

  calculateEvent:(name)=>
    return if !@element.hasAttribute(name)
    path = @element.getAttribute(name)
    index = path.lastIndexOf('.')
    parentPath = if index < 0 then 'window' else parentPath = path.substr(0, index)
    try
      method = eval path
      parent = eval parentPath
      @[name] = (event)=> method.apply(parent, [ @, event ]) if method? && method instanceof Function

BindIt.View.Text = TextView
BindIt.View.Default.textarea = TextView
BindIt.View.Input.byType.text = TextView
BindIt.View.Input.byType.password = TextView
BindIt.View.Input.byType.hidden = TextView
BindIt.View.Input.byType.email = TextView
BindIt.View.Input.byType.search = TextView
BindIt.View.Input.byType.tel = TextView
BindIt.View.Input.byType.color = TextView
BindIt.View.Input.byType.range = TextView
BindIt.View.Input.byType.number = TextView
BindIt.View.Input.byType.url = TextView
BindIt.View.Input.byType.time = TextView
BindIt.View.Input.byType.month = TextView
BindIt.View.Input.byType.week = TextView
BindIt.View.Input.byType.date = TextView
BindIt.View.Input.byType.datetime = TextView
BindIt.View.Input.byType['datetime-local'] = TextView