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
