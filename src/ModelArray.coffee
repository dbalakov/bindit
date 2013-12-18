BindIt.Model.ArrayEvents = { INSERTED: 'inserted', REMOVED : 'removed', APOCALYPTIC : 'apocalyptic' }

class ModelArray extends BindIt.Model
  constructor: (@source, hasSelectedItems) ->
    super(@source, true)
    BindIt.Model.processProperty @, 'length'

    #selectedItem
    @source.selectedItem = 0
    BindIt.Model.processProperty @, 'selectedItem'

    #selectedItems
    hasSelectedItems = true if !hasSelectedItems?
    if hasSelectedItems == true
      @source.selectedItems = 0
      BindIt.Model.processProperty @, 'selectedItems'
      @selectedItems = new BindIt.ModelArray [], false

    processArrayItems @

    @addEventListener BindIt.Model.Events.VALUE_CHANGED, (model, propertyName, oldValue, value)->
      return if (propertyName != 'length')
      return if (oldValue > value)
      processArrayItems model

  push: (value)->
    result = @getSource().push BindIt.getSource(value)
    processArrayItems @
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.INSERTED, @getSource().length - 1, BindIt.getModel(value) ]
    BindIt.getModel result

  pop: ()->
    result = @getSource().pop()
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.REMOVED, @getSource().length, BindIt.getModel result ]
    BindIt.getModel result

  concat: (value)->
    new BindIt.Model @getSource().concat(value)

  join: (value)->
    @getSource().join(value)

  reverse: ()->
    result = @getSource().reverse()
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.APOCALYPTIC ]
    BindIt.getModel result

  shift: ()->
    result = @getSource().shift()
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.REMOVED, 0, BindIt.getModel(result) ]
    BindIt.getModel result

  slice: ()->
    new BindIt.Model @getSource().slice.apply(@getSource(), arguments)

  sort: ()->
    result = @getSource().sort.apply(@getSource(), arguments)
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.APOCALYPTIC ]
    BindIt.getModel result

  splice: ()->
    result = @getSource().splice.apply(@getSource(), arguments)
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.APOCALYPTIC ]
    BindIt.getModel result

  unshift: (value)->
    result = @getSource().unshift BindIt.getSource(value)
    @callEvent BindIt.Model.Events.ARRAY_CHANGED, [ @, BindIt.Model.ArrayEvents.INSERTED, 0, BindIt.getModel(value) ]
    BindIt.getModel result

  indexOf: (value) ->
    @getSource().indexOf(BindIt.getSource(value))

processArrayItems = (model) ->
  BindIt.Model.processProperty(model, i) for i in [0..(model.length-1)]

window.BindIt.ModelArray = ModelArray