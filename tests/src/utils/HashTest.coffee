module 'Hash'

test 'add', ->
  hash = new BindIt.Hash
  hash.add 'name', 'Edgar Poe'

  equal hash.keys[0], 'name', 'See valid keys, after add'
  equal hash.values[0], 'Edgar Poe', 'See valid values, after add'

  hash.add 'name', 'Kurt Vonnegut'
  equal hash.values[0], 'Kurt Vonnegut', 'See valid values, after add existing key'

test 'remove', ->
  hash = new BindIt.Hash
  hash.add 'author', 'Edgar Poe'
  hash.add 'another author', 'Kurt Vonnegut'

  hash.remove 'author'
  equal hash.length, 1, 'length valid, after remove'
  equal hash.keys.length, 1, 'keys length valid, after remove'
  equal hash.values.length, 1, 'length valid, after remove'

  equal hash.keys[0], 'another author','keys valid, after remove'
  equal hash.values[0], 'Kurt Vonnegut', 'length valid, after remove'

test 'clear', ->
  hash = new BindIt.Hash
  hash.add 'author', 'Edgar Poe'
  hash.add 'another author', 'Kurt Vonnegut'

  hash.clear()

  equal hash.length, 0, 'length valid, after clear'
  equal hash.keys.length, 0, 'keys length valid, after clear'
  equal hash.values.length, 0, 'length valid, after clear'

test 'get', ->
  hash = new BindIt.Hash
  hash.add 'author', 'Edgar Poe'
  hash.add 'another author', 'Kurt Vonnegut'

  equal hash.get('author'), 'Edgar Poe', 'get returns valid value (key="author")'
  equal hash.get('another author'), 'Kurt Vonnegut', 'get returns valid value (key="another author")'

test 'getKeyByValue', ->
  hash = new BindIt.Hash
  hash.add 'author', 'Edgar Poe'
  hash.add 'another author', 'Kurt Vonnegut'

  equal hash.getKeyByValue('Edgar Poe'), 'author', 'returns valid value (value="Edgar Poe")'
  equal hash.getKeyByValue('Kurt Vonnegut'), 'another author', 'returns valid value (value="Kurt Vonnegut")'

test 'length', ->
  hash = new BindIt.Hash
  hash.add 'author', 'Edgar Poe'
  hash.add 'another author', 'Kurt Vonnegut'

  equal hash.length, 2, 'length returns valid value'