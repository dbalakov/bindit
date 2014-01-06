module 'Text'

test 'Constructor', ->
  window.model = new BindIt.Model { text : 'text' }

  equal createView('input', 'model:text', 'text').element.value, 'text', 'See valid value (input text)'
  equal createView('input', 'model:text', 'password').element.value, 'text', 'See valid value (input password)'
  equal createView('textarea', 'model:text').element.value, 'text', 'See valid value (textarea)'

  ok !createView('input', 'model:text', 'text').element.hasAttribute('disabled'), "Model isn't null, element enabled (input text)"
  ok !createView('input', 'model:text', 'password').element.hasAttribute('disabled'), "Model isn't null, element enabled (input password)"
  ok !createView('textarea', 'model:text').element.hasAttribute('disabled'), "Model isn't null, element enabled (textarea)"

  ok createView('input', 'model:null', 'text').element.hasAttribute('disabled'), "Model is null, element disabled (input text)"
  ok createView('input', 'model:null', 'password').element.hasAttribute('disabled'), "Model is null, element disabled (input password)"
  ok createView('textarea', 'model:null').element.hasAttribute('disabled'), "Model is null, element disabled (textarea)"

test 'Model changed', ->
  window.model = new BindIt.Model { text : 'text' }

  textView = createView('input', 'model:text', 'text')
  passwordView = createView('input', 'model:text', 'text')
  textAreaView = createView('textarea', 'model:text')

  window.model.text = 'another'

  equal textView.element.value, 'another', 'See valid value (input text)'
  equal passwordView.element.value, 'another', 'See valid value (input password)'
  equal textAreaView.element.value, 'another', 'See valid value (textarea)'

  window.model.text = null

  ok textView.element.hasAttribute('disabled'), 'Model is null, element disabled (input text)'
  ok passwordView.element.hasAttribute('disabled'), 'Model is null, element disabled (input password)'
  ok textAreaView.element.hasAttribute('disabled'), 'Model is null, element disabled (textarea)'

test 'Value changed', ->
  checkElementEvent 'change', createView('input', 'model:text', 'text'), 'input text'
  checkElementEvent 'change', createView('input', 'model:text', 'password'), 'input password'
  checkElementEvent 'change', createView('textarea', 'model:text'), 'textarea'

  checkElementEvent 'keyup', createView('input', 'model:text', 'text'), 'input text'
  checkElementEvent 'keyup', createView('input', 'model:text', 'password'), 'input password'
  checkElementEvent 'keyup', createView('textarea', 'model:text'), 'textarea'

  checkElementEvent 'paste', createView('input', 'model:text', 'text'), 'input text'
  checkElementEvent 'paste', createView('input', 'model:text', 'password'), 'input password'
  checkElementEvent 'paste', createView('textarea', 'model:text'), 'textarea'

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('textarea')), BindIt.View.Text, 'Default view for textarea tag is TextView'

  ok new BindIt.View.Input(createElement('input', null, 'text')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "text"'
  ok new BindIt.View.Input(createElement('input', null, 'password')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'hidden')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'email')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'search')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'tel')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'color')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'range')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'number')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'url')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'time')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'month')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'week')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'
  ok new BindIt.View.Input(createElement('input', null, 'date')) instanceof BindIt.View.Text, 'InputView constructor returns instance of TextView if type is "password"'

checkElementEvent = (eventType, view, tag)->
  window.model = new BindIt.Model { text : 'text' }
  view.element.value = 'new text'

  event = document.createEvent "HTMLEvents"
  event.initEvent eventType, false, true
  view.element.dispatchEvent event

  equal window.model.text, 'new text', "Value changed, model changed (#{tag}), event: #{eventType}"

createView = (tag, model, type)->
  element = createElement tag, model, type
  new BindIt.View.Text element

createElement = (tag, model, type)->
  element = document.createElement tag
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, model if model?
  element.setAttribute 'type', type if type?
  element