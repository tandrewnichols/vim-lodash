let g:vigor_types = {
  \   'number': type(0),
  \   'string': type(''),
  \   'function': type(function('tr')),
  \   'list': type([]),
  \   'dict': type({}),
  \   'float': type(0.0),
  \   'bool': type(v:false),
  \   'none': type(v:none),
  \   'job': 8,
  \   'channel': 9
  \ }

function! vigor#type#isNumber(thing) abort
  return type(a:thing) == g:vigor_types.number
endfunction

function! vigor#type#isString(thing) abort
  return type(a:thing) == g:vigor_types.string
endfunction

function! vigor#type#isFunction(thing) abort
  return type(a:thing) == g:vigor_types.function
endfunction

function! vigor#type#isFuncref(thing) abort
  return type(a:thing) == g:vigor_types.function
endfunction

function! vigor#type#isArray(thing) abort
  return type(a:thing) == g:vigor_types.list
endfunction

function! vigor#type#isList(thing) abort
  return type(a:thing) == g:vigor_types.list
endfunction

function! vigor#type#isObject(thing) abort
  return type(a:thing) == g:vigor_types.dict
endfunction

function! vigor#type#isDict(thing) abort
  return type(a:thing) == g:vigor_types.dict
endfunction

function! vigor#type#isNull(thing) abort
  return type(a:thing) == g:vigor_types.none
endfunction
