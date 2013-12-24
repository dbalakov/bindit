module 'Select'

test 'Default view', ()->
  equal BindIt.DOM.getViewClass(document.createElement('select')), BindIt.View.Select, 'Default view for select tag is Select'