BindIt.VIEW_ATTRIBUTE = 'view'

getViewClass = (element)->
  className = element.getAttribute BindIt.VIEW_ATTRIBUTE
  className = BindIt.View.Default[element.tagName.toLowerCase()] if !className?
  className = 'BindIt.View' if !className?
  result = BindIt.View
  try
    result = eval className
  result

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

addEventHandler = (element, event, handler)->
  return if !handler?

  return element.addEventListener(event, handler) if element.addEventListener?

BindIt.DOM = {
  getViewClass    : getViewClass,
  createView      : createView,
  processElement  : processElement,
  addEventHandler : addEventHandler
}

BindIt.View.Default = {}

#onload
onload = ()-> processElement document
(->
  BindIt.DOM.addEventHandler window, 'load', onload
  BindIt.DOM.addEventHandler window, 'DOMSubtreeModified', (e)-> processElement e.target
)()