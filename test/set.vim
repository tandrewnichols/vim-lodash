Before (Reset obj):
  unlet g:obj

Execute (_.set a basic object):
  let g:obj = g:_.set({}, 'foo', 'bar')

Then ('foo' == 'bar'):
  AssertEqual g:obj, { 'foo': 'bar' }

Execute (_.set a nested object):
  let g:obj = g:_.set({}, 'foo.bar', 'baz')

Then ('foo.bar' == 'baz'):
  AssertEqual g:obj, { 'foo': { 'bar': 'baz' }}

Execute (_.set an array index):
  let g:obj = g:_.set([], '0', 'bar')

Then ('0' == 'bar'):
  AssertEqual g:obj, ['bar']

Execute (_.set a nested array index):
  let g:obj = g:_.set({}, 'foo.0', 'bar')

Then ('foo.0' == 'bar'):
  AssertEqual g:obj, { 'foo': ['bar'] }

" Execute (_.set an object within an array):
"   let g:obj = g:_.set({}, 'foo.0.bar', 'baz')
"
" Then ('foo.0.bar' == 'baz')
"   call assert_equal(g:obj, { 'foo': [{'bar': 'baz' }] })
