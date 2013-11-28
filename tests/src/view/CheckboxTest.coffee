module 'Checkbox'

test 'Constructor', ->
  window.model = new BindIt.Model { t : true, f : false, n : null, s : '12qwe' }

  trueView  = createView 'model:t'
  falseView = createView 'model:f'
  nullView  = createView 'model:n'
  strView   = createView 'model:s'

  #value
  ok trueView.element.checked, 'See valid value (true)'
  ok !falseView.element.checked, 'See valid value (false)'
  ok !nullView.element.checked, 'See valid value (null)'
  ok !strView.element.checked, 'See valid value (string)'

  #enabled
  ok !trueView.element.hasAttribute('disabled'), 'See valid element enabled (true)'
  ok !falseView.element.hasAttribute('disabled'), 'See valid element enabled (false)'
  ok nullView.element.hasAttribute('disabled'), 'See valid element enabled (null)'
  ok strView.element.hasAttribute('disabled'), 'See valid element enabled (string)'

test 'Value changed', ->
  window.model = new BindIt.Model { t : false, f : true }

  trueView  = createView 'model:t'
  falseView = createView 'model:f'

  changeCheckboxValue trueView.element, true
  changeCheckboxValue falseView.element, false

  equal window.model.t, true, 'Element value changed, model changed (from false to true)'
  equal window.model.f, false, 'Element value changed, model changed (from true to false)'

test 'Model changed', ->
  window.model = new BindIt.Model { t : false, f : true, n : true, s : true }

  trueView  = createView 'model:t'
  falseView = createView 'model:f'
  nullView  = createView 'model:n'
  strView   = createView 'model:s'

  window.model.t = true
  window.model.f = false
  window.model.n = null
  window.model.s = 'qwer'

  #value
  ok trueView.element.checked, 'See valid value (true)'
  ok !falseView.element.checked, 'See valid value (false)'
  ok !nullView.element.checked, 'See valid value (null)'
  ok !strView.element.checked, 'See valid value (string)'

  #enabled
  ok !trueView.element.hasAttribute('disabled'), 'See valid element enabled (true)'
  ok !falseView.element.hasAttribute('disabled'), 'See valid element enabled (false)'
  ok nullView.element.hasAttribute('disabled'), 'See valid element enabled (null)'
  ok strView.element.hasAttribute('disabled'), 'See valid element enabled (string)'

test 'Default view', ->
  ok new BindIt.View.Input(createInputCheckbox()) instanceof BindIt.View.Checkbox, 'InputView constructor returns instance of CheckboxView if type is "checkbox"'

createInputCheckbox = (model)->
  element = document.createElement 'input'
  element.setAttribute 'type', 'checkbox'
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, model if model?
  element

createView = (model)->
  new BindIt.View.Checkbox createInputCheckbox model

changeCheckboxValue = (element, value)->
  element.checked = value

  event = document.createEvent "HTMLEvents"
  event.initEvent 'change', false, true
  element.dispatchEvent event