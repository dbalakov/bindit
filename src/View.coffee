BindIt.BIND_DATA_ATTRIBUTE = "data-bind";

class View extends EventDispatcher
  constructor: (@element) ->

  #TODO test it
  getModelPath: ()->
    bindingObject = this.element.getAttribute(BindIt.BIND_DATA_ATTRIBUTE);
    return null if (bindingObject == null)
    parts = bindingObject.split ":"
    return if parts.length == 0 then null else parts

window.View = View