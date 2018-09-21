let s:types = {
  \   'number': 0,
  \   'string': 1,
  \   'function': 2,
  \   'list': 3,
  \   'dict': 4,
  \   'float': 5,
  \   'bool': 6,
  \   'none': 7,
  \   'job': 8,
  \   'channel': 9
  \ }

function! vigor#type#isNumber(thing)
  return type(a:thing) == s:types.number
endfunction

function! vigor#type#isString(thing)
  return type(a:thing) == s:types.string
endfunction

function! vigor#type#isFunction(thing)
  return type(a:thing) == s:types.function
endfunction

function! vigor#type#isFuncref(thing)
  return type(a:thing) == s:types.function
endfunction

function! vigor#type#isArray(thing)
  return type(a:thing) == s:types.list
endfunction

function! vigor#type#isList(thing)
  return type(a:thing) == s:types.list
endfunction

function! vigor#type#isObject(thing)
  return type(a:thing) == s:stypes.dict
endfunction

function! vigor#type#isDict(thing)
  return type(a:thing) == s:stypes.dict
endfunction
