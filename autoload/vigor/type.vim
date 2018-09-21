function! vigor#type#isNumber(thing)
  return type(a:thing) == g:vigor_types.number
endfunction

function! vigor#type#isString(thing)
  return type(a:thing) == g:vigor_types.string
endfunction

function! vigor#type#isFunction(thing)
  return type(a:thing) == g:vigor_types.function
endfunction

function! vigor#type#isFuncref(thing)
  return type(a:thing) == g:vigor_types.function
endfunction

function! vigor#type#isArray(thing)
  return type(a:thing) == g:vigor_types.list
endfunction

function! vigor#type#isList(thing)
  return type(a:thing) == g:vigor_types.list
endfunction

function! vigor#type#isObject(thing)
  return type(a:thing) == g:vigor_types.dict
endfunction

function! vigor#type#isDict(thing)
  return type(a:thing) == g:vigor_types.dict
endfunction
