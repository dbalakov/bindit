class SelectItemView
  init:(view)->
    view.element.onchange = ->
      model = view.getValue(true)
      return if !model?
      model.selectedItem = parseInt view.element.value

  create:(model, index, selected)->
    element = document.createElement 'option'
    element.innerHTML = model[index]
    element.setAttribute 'value', index
    @setSelected element, model, index, selected
    element

  changed:(element, model, index, selected)->
    element.innerHTML = model[index]
    @setSelected element, model, index, selected

  setSelected:(element, model, index, selected)->
    return element.setAttribute 'selected', '' if selected
    element.removeAttribute 'selected'

SelectItemView.instance = new SelectItemView

class Select extends BindIt.View.List
  constructor: (@element) ->
    super @element

  calculateItemView:->
    @itemView = SelectItemView.instance

Select.ItemView = SelectItemView
BindIt.View.Select = Select
BindIt.View.Default.select = Select