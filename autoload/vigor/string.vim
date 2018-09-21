function! vigor#string#upperFirst(thing)
  return substitute(a:thing, '^\([a-z]\)', '\U\1', '')
endfunction

function! vigor#string#includes(str, pat)
  return match(a:str, a:pat) > -1
endfunction

function! vigor#string#trim(str)
  return substitute(substitute(a:str, '^ \+', '', ''), ' \+$', '', '')
endfunction

function! vigor#string#pad(str, len, ...)
  let sep = a:0 == 1 ? a:1 : ' '
  if len(a:str) < a:len
    let paddingLen = a:len - len(a:str)
    if self.isEven(paddingLen)
      let padding = repeat(sep, paddingLen / 2)
      return padding . a:str . padding
    else
      let padding = repeat(sep, (paddingLen - 1) / 2)
      return padding . sep . a:str . padding
    endif
  else
    return a:str
  endif
endfunction

function! vigor#string#padStart(str, len, ...)
  let sep = a:0 == 1 ? a:1 : ' '
  if len(a:str) < a:len
    let padding = repeat(sep, a:len - len(a:str))
    return padding . a:str
  else
    return a:str
  endif
endfunction

function! vigor#string#padEnd(str, len, ...)
  let sep = a:0 == 1 ? a:1 : ' '
  if len(a:str) < a:len
    let padding = repeat(sep, a:len - len(a:str))
    return a:str . padding
  else
    return a:str
  endif
endfunction
