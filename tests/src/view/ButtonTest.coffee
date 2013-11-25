module 'Button'

test 'Constructor', ()->
  window.model = new BindIt.Model {
    func : (()->),
    str : '123',
    number : 42,
    obj : {},
    funcObj: { enabled : true, call : ()-> },
    funcObjFalse: { enabled : false, call : ()-> },
    funcObjNull: { enabled : null, call : ()-> },
    funcObjEnabledReturnsTrue: { enabled : (()-> true), call : ()-> },
    funcObjEnabledReturnsFalse: { enabled : (()-> false), call : ()-> }
  }

  ok createButtonViewDataBindAttribute('model:null').element.hasAttribute('disabled'), 'Model is null, button disabled'
  ok !createButtonViewDataBindAttribute('model:func').element.hasAttribute('disabled'), 'Model is function, button enabled'
  ok !createButtonViewDataBindAttribute('model:funcObj').element.hasAttribute('disabled'), 'Model is valid object (enabled - true), button enabled'
  ok createButtonViewDataBindAttribute('model:str').element.hasAttribute('disabled'), 'Model is string, button disabled'
  ok createButtonViewDataBindAttribute('model:number').element.hasAttribute('disabled'), 'Model is number, button disabled'
  ok createButtonViewDataBindAttribute('model:obj').element.hasAttribute('disabled'), 'Model is invalid object, button disabled'
  ok createButtonViewDataBindAttribute('model:funcObjFalse').element.hasAttribute('disabled'), 'Model is valid object (enabled - false), button disabled'
  ok createButtonViewDataBindAttribute('model:funcObjNull').element.hasAttribute('disabled'), 'Model is valid object (enabled - false), button disabled'
  ok !createButtonViewDataBindAttribute('model:funcObjEnabledReturnsTrue').element.hasAttribute('disabled'), 'Model is valid object (enabled - function, returns true), button enabled'
  ok createButtonViewDataBindAttribute('model:funcObjEnabledReturnsFalse').element.hasAttribute('disabled'), 'Model is valid object (enabled - function, returns true), button disabled'

test 'Click to call bind function', ()->
  window.model = new BindIt.Model { func: (()->), obj: { enabled:true, call:()-> } }
  expectCall window.model, 'func'
  expectCall window.model.obj, 'call'

  click createButtonViewDataBindAttribute('model:func').element
  click createButtonViewDataBindAttribute('model:obj').element

test 'Change model, call setEnabled', ()->
  window.model = new BindIt.Model { func : ()-> }
  view = createButtonViewDataBindAttribute 'model:func'
  expectCall view, 'setEnabled'

  window.model.func = null

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('button')), BindIt.View.Button, 'Default view for button tag is ButtonView'
  equal BindIt.DOM.getViewClass(document.createElement('a')), BindIt.View.Button, 'Default view for tag "a" is ButtonView'

createButtonViewDataBindAttribute = (dataBind)->
  element = document.createElement 'button'
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, dataBind
  new BindIt.View.Button element

click = (element)->
  event = document.createEvent('MouseEvents')
  event.initMouseEvent 'click', true, true, window, 0, 1, 2, 3, 4, false, false, true, false, 0, null
  element.dispatchEvent event