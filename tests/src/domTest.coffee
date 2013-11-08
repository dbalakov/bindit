module 'dom'

class TestView extends BindIt.View
class DivView extends BindIt.View
window.TestView = TestView
BindIt.View.Default.div = DivView

asyncTest 'DOM events', 2, ->
  notEqual document.getElementById('domTest_loading').__bindit_view, undefined, 'View was create after dom ready'

  div = createElement 'div', 'domTest.model'
  document.getElementById('trash').appendChild div
  notEqual div.__bindit_view, undefined, 'View was create after dom changed'
  start()

test 'getViewClass', ()->
  equal BindIt.DOM.getViewClass(createElement 'div', 'domTest.model', 'TestView'), TestView, 'getViewClass returns view class from attribute'
  equal BindIt.DOM.getViewClass(createElement 'div', 'domTest.model'), DivView, 'getViewClass returns default view class'

createElement = (tag, data, view)->
  div = document.createElement tag
  div.setAttribute BindIt.DATA_BIND_ATTRIBUTE, data if data?
  div.setAttribute BindIt.VIEW_ATTRIBUTE, view if view?
  div
