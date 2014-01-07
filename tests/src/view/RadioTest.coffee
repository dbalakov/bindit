module 'Radio'

test 'Constructor', ->
  window.model = new BindIt.Model { value : 'q' }

  checkedView = createViewRadio 'model:value', 'q'
  uncheckedView = createViewRadio 'model:value', 'w'
  disabledView = createViewRadio 'model:null', 'q'

  ok checkedView.element.hasAttribute('checked'), 'Element checked'
  ok !uncheckedView.element.hasAttribute('checked'), 'Element unchecked'
  ok !checkedView.element.hasAttribute('disabled'), 'Element enabled'
  ok disabledView.element.hasAttribute('disabled'), 'Element disabled'

test 'Checked changed', ->
  window.model = new BindIt.Model { value : 'q' }

  qView = createViewRadio 'model:value', 'q'
  wView = createViewRadio 'model:value', 'w'

  wView.element.checked = true
  wView.element.onchange()

  equal model.value, 'w', 'Model changed'

test 'Model changed', ->
  window.model = new BindIt.Model { value : 'w', null : 1 }

  checkedView = createViewRadio 'model:value', 'q'
  uncheckedView = createViewRadio 'model:value', 'w'
  disabledView = createViewRadio 'model:null', 'q'

  model.value = 'q'
  model.null = null

  ok checkedView.element.hasAttribute('checked'), 'Element checked'
  ok !uncheckedView.element.hasAttribute('checked'), 'Element unchecked'
  ok !checkedView.element.hasAttribute('disabled'), 'Element enabled'
  ok disabledView.element.hasAttribute('disabled'), 'Element disabled'

test 'Default view', ->
  ok new BindIt.View.Input(createInputRadio(null, null)) instanceof BindIt.View.Radio, 'InputView constructor returns instance of RadioView if type is "radio"'

createInputRadio = (model, value)->
  element = document.createElement 'input'
  element.setAttribute 'type', 'radio'
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, model if model?
  element.setAttribute 'value', value if value?
  element

createViewRadio = (model, value)->
  new BindIt.View.Input createInputRadio(model, value)