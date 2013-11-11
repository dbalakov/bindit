module 'Templates'

test 'constructor', ()->
  ok new BindIt.Template({ tag : 'div' }) instanceof BindIt.Template, 'Constructor returns valid type'

  template = new BindIt.Template { tag : 'div' }
  equal new BindIt.Template(template), template, 'Constructor returns source, when source is instance of Template'

test 'create', ()->
  ok (new BindIt.Template({ tag : 'div' }).create()) instanceof Element, 'Create returns dom element'
  ok (new BindIt.Template({ }).create()) instanceof DocumentFragment, 'Create returns document fragment, when tag is null'

test 'tag', ()->
  equal (new BindIt.Template({ tag : 'div' }).create()).tagName, 'DIV', 'Function create returns element with valid tag name'
  equal (new BindIt.Template({ tag : (a, b, c)-> a + b + c }).create('d', 'i', 'v')).tagName, 'DIV', 'Function create returns element with valid tag name from function'

test 'attributes', ()->
  equal (new BindIt.Template({ tag : 'div', attributes : (a)-> { test : a } }).create('123')).getAttribute('test'), '123', 'Function create returns element with valid attribute from function'
  equal (new BindIt.Template({ tag : 'div', attributes : { test : '123' } }).create()).getAttribute('test'), '123', 'Function create returns element with valid attribute'
  equal (new BindIt.Template({ tag : 'div', attributes : { test : (a, b)-> a + b } }).create('va', 'lue')).getAttribute('test'), 'value', 'Function create returns element with valid attribute'
  assertOftenAttribute attr for attr in BindIt.Template.OftenAttributes

test 'html', ()->
  equal (new BindIt.Template({ tag : 'div', html : '<a>inner html</a>' })).create().innerHTML, '<a>inner html</a>', 'Function create returns element with valid innerHTML'
  equal (new BindIt.Template({ tag : 'div', html : (a, b, c)-> "<a>#{a}#{b}#{c}</a>" })).create('q', 'w', 'e').innerHTML, '<a>qwe</a>', 'Function create returns element with valid innerHTML from function'

test 'text', ()->
  equal (new BindIt.Template({ tag : 'div', text : 'inner text' })).create().innerText, 'inner text', 'Function create returns element with valid innerText'
  equal (new BindIt.Template({ tag : 'div', text : (a, b, c)-> "#{a}#{b}#{c}" })).create('q', 'w', 'e').innerText, 'qwe', 'Function create returns element with valid innerText from function'

test 'child', ()->
  div = document.createElement 'div'
  div['template-id'] = 'el'
  template = new BindIt.Template { tag : 'div', child : [ { tag : 'a', 'template-id' : 'a' }, new BindIt.Template({ tag : 'br', 'template-id' : 'br' }), ((a, b, c)-> c + b + a), ((a, b, c)-> { tag : ((q, w, e)->q + w + e), 'template-id' : 'func' }), div ] }
  element = template.create('d', 'i', 'v')

  #size
  equal element.childNodes.length, 5, 'Function create returns element with child nodes'

  #child
  equal element.childNodes[0].tagName, 'A', 'Function create created valid tag from object'
  equal element.childNodes[1].tagName, 'BR', 'Function create created valid tag from Template'
  ok element.childNodes[2] instanceof Text, 'Function create created valid tag from function'
  equal element.childNodes[3].tagName, 'DIV', 'Function create created valid tag from function'

  #template id
  equal element.a, element.childNodes[0]
  equal element.br, element.childNodes[1]
  equal element.func, element.childNodes[3]
  equal element.el, element.childNodes[4]

test 'Only one available: html, text, child', ()->
  throws (-> new BindIt.Template({ html : '1', text : '2' }).create()), 'Only one available: html, text'
  throws (-> new BindIt.Template({ html : '1', child : [] }).create()), 'Only one available: html, child'
  throws (-> new BindIt.Template({ text : '1', child : [] }).create()), 'Only one available: text, child'

assertOftenAttribute = (attr)->
  #string
  template = { tag : 'div' }
  template[attr] = 'ddd'
  equal (new BindIt.Template(template).create()).getAttribute(attr), 'ddd', "Create returns valid #{attr}"

  #function
  template = { tag : 'div' }
  template[attr] = (a, b, c)-> a + b + c
  equal (new BindIt.Template(template).create('q', 'w', 'e')).getAttribute(attr), 'qwe', "Create returns valid #{attr} from function"