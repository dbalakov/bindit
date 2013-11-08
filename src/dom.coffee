BindIt.VIEW_ATTRIBUTE = 'view'

getViewClass = (element)->
  className = element.getAttribute BindIt.VIEW_ATTRIBUTE
  className = BindIt.View.Default[element.tagName.toLowerCase()] if !className?
  className = BindIt.View if !className?
  return eval className #TODO try catch

createView = (element)->
  return if !element?
  return if element.__bindit_view?
  return if !element.getAttribute?
  data = element.getAttribute BindIt.DATA_BIND_ATTRIBUTE
  return if !data?
  new (getViewClass(element))(element)

processElement = (parent)->
  createView parent
  return if !parent.getElementsByTagName?
  elements = parent.getElementsByTagName '*'
  createView(element) for element in elements

#onload
onload = ()-> processElement document
(->
  return window.addEventListener 'load', onload if window.addEventListener?
)()

#dom tree changed
(->
  return window.addEventListener 'DOMSubtreeModified', (e)-> processElement e.target if window.addEventListener?
)()

BindIt.DOM = {
  getViewClass : getViewClass,
  createView : createView,
  processElement : processElement
}

BindIt.View.Default = {}