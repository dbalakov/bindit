class SelectItemView
  create:(model, item, selected)->
    option = document.createElement 'option'
    option.innerHTML = item
    option.setAttribute 'value',
    option

  changed:(model, item, selected)->

SelectItemView.instance = new SelectItemView

class Select extends BindIt.View.List
  constructor: (@element) ->
    super @element

  calculateItemView:->
    SelectItemView.instance

BindIt.View.Select = Select

BindIt.View.Default.select = Select