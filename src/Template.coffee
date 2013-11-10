class Template
  constructor: (@template) ->
    return @template if @template instanceof Template

  create:=>
    tagName = getValue(@, @template.tag, arguments)
    result = if tagName? then document.createElement tagName else document.createDocumentFragment()
    fillAttributes @, result, arguments
    fillChild @, result, arguments
    result

fillAttributes = (t, element, args)->
  attributes = t.template.attributes
  attributes = {} if !attributes?
  attributes = getValue t, attributes, args
  (attributes[attr] = t.template[attr] if t.template[attr]?) for attr in Template.OftenAttributes

  for attr of attributes
    value = attributes[attr]
    value = getValue @, value, args
    element.setAttribute attr, value

fillChild = (t, element, args)->
  html = getValue t, t.template.html, args
  text = getValue t, t.template.text, args
  child = getValue t, t.template.child, args

  count = (if html? then 1 else 0) + (if text? then 1 else 0) + (if child? then 1 else 0)
  throw new Error('Template exception. Only one available: html, text, child') if count > 1

  element.innerHTML = html if html?
  element.innerText = text if text?
  (appendChild(t, element, node, args) for node in child) if child?

appendChild = (template, element, node, args)->
  child = node
  child = child.apply(template, args) if child instanceof Function
  return element.appendChild(document.createTextNode(child)) if typeof(child) == 'string'
  if child instanceof Node
    element[node[Template.TEMPLATE_ID_PROPERTY]] = node if node[Template.TEMPLATE_ID_PROPERTY]?
    return element.appendChild(node) if child instanceof Node
  if child instanceof Object
    childTemplate = new Template(child)
    templateId = childTemplate[Template.TEMPLATE_ID_PROPERTY] if childTemplate[Template.TEMPLATE_ID_PROPERTY]?
    templateId = childTemplate.template[Template.TEMPLATE_ID_PROPERTY] if childTemplate.template[Template.TEMPLATE_ID_PROPERTY]? && !templateId?
    elementNode = childTemplate.create.apply(child, args)
    element[templateId] = elementNode if templateId?
    return element.appendChild elementNode


getValue = (template, property, args)->
  result = property
  result = property.apply(template, args) if property instanceof Function
  result

Template.OftenAttributes = [ 'id', 'name', 'class', 'style', 'src', 'href', 'value', BindIt.DATA_BIND_ATTRIBUTE, BindIt.VIEW_ATTRIBUTE ]
Template.TEMPLATE_ID_PROPERTY = 'template-id'
BindIt.Template = Template