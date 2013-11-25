class ButtonView extends BindIt.View
  constructor: (@element) ->
    super @element
    @setEnabled @getModel(false)
    @click ()=>
      model = @getModel false
      return if !@getEnabled(model)
      return @callBindFunction() if model instanceof Function
      model.call.apply(model) if model.call instanceof Function

  changed: ()-> @setEnabled @getModel(false)

  setEnabled: (model)->
    return @element.removeAttribute 'disabled' if @getEnabled(model)
    @element.setAttribute 'disabled', 'disabled'

  getEnabled: (model)->
    return false if model == null
    return true if model instanceof Function
    enabled = model.enabled if model instanceof Object
    enabled = enabled.apply model if enabled instanceof Function
    enabled == true && (model instanceof Function || model.call instanceof Function)

BindIt.View.Button = ButtonView
BindIt.View.Default.button = ButtonView
BindIt.View.Default.a = ButtonView