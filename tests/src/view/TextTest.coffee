module 'Text'

test 'Constructor', ->
  window.model = new BindIt.Model { text : 'text' }

  equal createView('input', 'model:text', 'text').element.value, 'text', 'See valid value (input)'
  equal createView('textarea', 'model:text').element.value, 'text', 'See valid value (textarea)'

  ok !createView('input', 'model:text', 'text').element.hasAttribute('disabled'), "Model isn't null, element enabled (input)"
  ok !createView('textarea', 'model:text').element.hasAttribute('disabled'), "Model isn't null, element enabled (textarea)"
  ok createView('input', 'model:null', 'text').element.hasAttribute('disabled'), "Model is null, element disabled (input)"
  ok createView('textarea', 'model:null').element.hasAttribute('disabled'), "Model is null, element disabled (textarea)"

test 'Model changed', ->
  window.model = new BindIt.Model { text : 'text' }

  inputView = createView('input', 'model:text', 'text')
  textAreaView = createView('textarea', 'model:text')

  window.model.text = 'another'

  equal inputView.element.value, 'another', 'See valid value (input)'
  equal textAreaView.element.value, 'another', 'See valid value (input)'

  window.model.text = null

  ok inputView.element.hasAttribute('disabled'), 'Model is null, element disabled (input)'
  ok textAreaView.element.hasAttribute('disabled'), 'Model is null, element disabled (textarea)'

test 'Value changed', ->
  checkElementEvent 'change', createView('input', 'model:text', 'text'), 'input'
  checkElementEvent 'change', createView('textarea', 'model:text'), 'textarea'

  checkElementEvent 'keyup', createView('input', 'model:text', 'text'), 'input'
  checkElementEvent 'keyup', createView('textarea', 'model:text'), 'textarea'

  checkElementEvent 'paste', createView('input', 'model:text', 'text'), 'input'
  checkElementEvent 'paste', createView('textarea', 'model:text'), 'textarea'

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('textarea')), BindIt.View.Text, 'Default view for textarea tag is TextView'

  element = document.createElement 'input'
  element.setAttribute 'type', 'text'
  ok new BindIt.View.Input(element) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "text"'

checkElementEvent = (eventType, view, tag)->
  window.model = new BindIt.Model { text : 'text' }
  view.element.value = 'new text'

  event = document.createEvent "HTMLEvents"
  event.initEvent eventType, false, true
  view.element.dispatchEvent event

  equal window.model.text, 'new text', "Value changed, model changed (#{tag}), event: #{eventType}"

createView = (tag, model, type)->
  element = document.createElement tag
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, model
  element.setAttribute 'type', type if type?
  new BindIt.View.Text element