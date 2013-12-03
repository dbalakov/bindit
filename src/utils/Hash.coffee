class Hash
  constructor:->
    @keys = []
    @values = []

    Object.defineProperty @, 'length', { get: -> @keys.length }

  add: (key, value)->
    index = @keys.indexOf key
    if index < 0
      @keys.push key
      @values.push value
      return
    @values[index] = value

  remove: (key)->
    index = @keys.indexOf key
    return if index < 0

    @keys.splice index, 1
    @values.splice index, 1

  clear: ->
    @keys.length = 0
    @values.length = 0

  get: (key)->
    index = @keys.indexOf key
    @values[index]

  length:->
    @keys.length

BindIt.Hash = Hash