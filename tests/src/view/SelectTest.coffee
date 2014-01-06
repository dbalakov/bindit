module 'Select'

test 'Constructor: valid itemView', ->
  window.model = new BindIt.Model [ 1, 2 ]
  view = createSelect 'model'
  equal view.itemView, BindIt.View.Select.ItemView.instance, 'calculateItemView return valid itemView'

test 'create', ->
  element = BindIt.View.Select.ItemView.instance.create new BindIt.Model([ 'asd', 'sda' ]), 0, false
  selectedElement = BindIt.View.Select.ItemView.instance.create new BindIt.Model([ 'asd', 'sda' ]), 0, true

  equal element.tagName, 'OPTION', 'Valid tag'
  equal element.innerHTML, 'asd', 'Valid innerHTML'
  equal element.getAttribute('value'), 0, 'Valid value'

  equal element.attributes.getNamedItem('selected'), null, 'Valid unselected'
  notEqual selectedElement.attributes.getNamedItem('selected'), null, 'Valid selected'

test 'changed', ->
  element = BindIt.View.Select.ItemView.instance.create new BindIt.Model([ 'asd', 'sda' ]), 0, false

  BindIt.View.Select.ItemView.instance.changed element, [ 'new', '123' ], 0, true

  equal element.innerHTML, 'new', 'Valid innerHTML'
  notEqual element.attributes.getNamedItem('selected'), null, 'Valid selected'

  BindIt.View.Select.ItemView.instance.changed element, [ 'new', '123' ], 0, false

  equal element.attributes.getNamedItem('selected'), null, 'Valid unselected'

test 'value changed, selectedItem changed', ->
  window.model = new BindIt.Model [ 1, 2 ]
  view = createSelect 'model'
  view.element.value = 1
  view.element.onchange()

  equal model.selectedItem, 1

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('select')), BindIt.View.Select, 'Default view for select tag is Select'

createSelect = (model)->
  element = document.createElement 'select'
  element.setAttribute BindIt.DATA_BIND_ATTRIBUTE, model if model?
  new BindIt.View.Select element