BindIt.DATA_BIND_ATTRIBUTE = "data-bind";
BindIt.FORM_BIND_ATTRIBUTE = "form-bind";

class View extends BindIt.DOMEventDispatcher
  constructor: (@element) ->
    throw new Error('Element should have only one view') if @element.__bindit_view?
    super @element
    element.__bindit_view = @
    @subscribes = []
    @refreshSubscribes()

  getValue: (returnArray)->
    path = @getModelPath()
    return null if !path? || path.length == 0
    try
      result = eval path.shift()

    while path.length > 0
      return null if !result?
      result = result[result.selectedItem] if result instanceof BindIt.ModelArray
      result = result[path.shift()]

    result = result[result.selectedItem] if result instanceof BindIt.ModelArray && returnArray != true
    return result

  setValue:(value)->
    modelPath = @getModelPath()
    modelPath = [] if !modelPath?
    parent = window
    while modelPath.length > 1
      return if !parent?
      parent = parent[parent.selectedItem] if parent instanceof BindIt.ModelArray
      return if !parent?
      parent = parent[modelPath.shift()]

    return if !parent?
    parent = parent[parent.selectedItem] if parent instanceof BindIt.ModelArray
    return if !parent?
    parent[modelPath[0]] = value

  callBindFunction:()->
    modelPath = @getModelPath()
    modelPath = [] if !modelPath?
    parent = null
    model = window
    while modelPath.length > 0
      break if !model?
      if model instanceof BindIt.ModelArray
        parent = model
        model = model[model.selectedItem]
      break if !model?
      parent = model
      model = model[modelPath.shift()]

    return if !model? || !(model instanceof Function)
    model.apply parent, arguments

  getModelPath: ->
    bindingPath = @element.getAttribute(BindIt.DATA_BIND_ATTRIBUTE);
    return null if (bindingPath == null)
    parent = @element.parentNode
    while (parent != null)
      bindingPath = "#{parent.getAttribute(BindIt.FORM_BIND_ATTRIBUTE)}:#{bindingPath}" if parent.hasAttribute? && parent.hasAttribute BindIt.FORM_BIND_ATTRIBUTE
      parent = parent.parentNode

    bindingPath.split ":"

  modelHandler: (model, property, oldValue, newValue)=>
    @refreshSubscribes()
    @changed? @, model, BindIt.Model.Events.VALUE_CHANGED, property, oldValue, newValue

  modelArrayHandler: (model, type, index, value)=>
    @refreshSubscribes()
    @changed? @, model, BindIt.Model.Events.ARRAY_CHANGED, type, index, value

  refreshSubscribes: ->
    modelPath = @getModelPath()
    modelPath = [] if !modelPath?
    model = window
    newSubscribes = []
    while modelPath.length > 0
      break if !model?
      if model instanceof BindIt.ModelArray
        model = model[model.selectedItem]
        newSubscribes.push model if model instanceof BindIt.Model
      break if !model?
      model = model[modelPath.shift()]
      newSubscribes.push model if model instanceof BindIt.Model

    @fillSubscribes model, newSubscribes, false
    toUnsubscribe = []
    toSubscribe = []
    (toSubscribe.push m if @subscribes.indexOf(m) < 0) for m in newSubscribes
    (toUnsubscribe.push m if newSubscribes.indexOf(m) < 0) for m in @subscribes
    for m in toSubscribe
      m.addEventListener BindIt.Model.Events.VALUE_CHANGED, @modelHandler
      m.addEventListener BindIt.Model.Events.ARRAY_CHANGED, @modelArrayHandler if m instanceof BindIt.ModelArray

    for m in toUnsubscribe
      m.removeEventListener BindIt.Model.Events.VALUE_CHANGED, @modelHandler
      m.removeEventListener BindIt.Model.Events.ARRAY_CHANGED, @modelArrayHandler if m instanceof BindIt.ModelArray

    @subscribes = newSubscribes

  fillSubscribes: (model, subscribes, returnIfModelExists)->
    return if !model? || !(model instanceof BindIt.Model)
    return if subscribes.indexOf(model) >= 0 && returnIfModelExists
    subscribes.push model if subscribes.indexOf(model) < 0
    if model instanceof BindIt.ModelArray
      @fillSubscribes model.selectedItems, subscribes, true
      @fillSubscribes item, subscribes, true for item in model
      return
    @fillSubscribes model[property], subscribes, true for property of model

BindIt.View = View