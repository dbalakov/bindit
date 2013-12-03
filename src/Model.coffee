class Model extends BindIt.EventDispatcher
  constructor: (@source, inner) ->
    @source = {} if !@source?
    return @source if @source instanceof Model
    return @source.__bindit_model if @source.__bindit_model?
    return new BindIt.ModelArray(@source) if ((@source instanceof Array) && inner != true)
    super()
    Object.defineProperty @source, '__bindit_model', {
      get: (-> @).bind(@)
      enumerable : false
    }

    (processProperty(@, property) for property of @source) unless (@source instanceof Array)

  getSource: ()-> @source

getModel = (source)->
  return null if !source?
  return new Model(source) if source instanceof Object
  return source

getSource = (model)->
  return null if !model?
  return model.getSource() if model instanceof Model
  return model

processProperty = (model, propertyName) ->
  return if model.hasOwnProperty propertyName
  Object.defineProperty model, propertyName, {
    get: ->
      result = model.getSource()[propertyName]
      return null if !result?
      return result.bind(model) if (result instanceof Function)
      result = new Model(result) if (result instanceof Object)
      return result

    set: (value) ->
      source = model.getSource()
      sourceValue = source[propertyName]
      value = value.getSource() if value instanceof Model

      return if sourceValue == value
      source[propertyName] = value
      @callEvent Model.Events.VALUE_CHANGED, [ model, propertyName, getModel(sourceValue), getModel(value) ]

    enumerable : true
  }

Model.processProperty = processProperty
Model.Events = { VALUE_CHANGED : "value_changed", ARRAY_CHANGED : 'array_changed' }

window.BindIt.Model = Model
window.BindIt.getModel = getModel
window.BindIt.getSource = getSource