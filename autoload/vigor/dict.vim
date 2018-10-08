function! vigor#dict#extend(dest, ...) abort
  let srcs = a:000
  for src in srcs
    call extend(a:dest, src)
  endfor

  return a:dest
endfunction

function! vigor#dict#defaults(dest, ...) abort
  let srcs = a:000
  for src in srcs
    call extend(a:dest, src, 'keep')
  endfor

  return a:dest
endfunction

function! vigor#dict#defaultsDeep(dest, ...) abort
  let dest = a:dest
  let srcs = a:000
  for src in srcs
    for [k,v] in items(src)
      if !has_key(dest, k)
        let dest[k] = deepcopy(src[k])
      elseif type(v) == g:vigor_types.dict
        call vigor#dict#defaultsDeep(dest[k], v)
      endif
    endfor
  endfor

  return dest
endfunction

function! vigor#dict#merge(dest, ...) abort
  let dest = a:dest
  let srcs = a:000
  for src in srcs
    for [k,v] in items(src)
      if type(v) == g:vigor_types.dict
        if !has_key(dest, k)
          let dest[k] = deepcopy(src[k])
      else
          let dest[k] = vigor#dict#merge(dest[k], v)
        endif
      else
        let dest[k] = v
      endif
    endfor
  endfor

  return dest
endfunction

function! vigor#dict#get(obj, path, ...) abort
  let default = a:0 == 1 ? a:1 : v:null
  let path = s:NormalizePath(a:path)
  let obj = a:obj
  for segment in path
    let obj = get(obj, segment, v:null)
    if vigor#type#isNull(obj)
      return default
    elseif !vigor#type#isDict(obj) && !vigor#type#isList(obj)
      return obj
    endif
  endfor
endfunction

function! vigor#dict#has(obj, path) abort
  let path = s:NormalizePath(a:path)
  let obj = a:obj
  for segment in path
    let obj = get(obj, segment, v:null)
    if vigor#type#isNull(obj)
      return 0
    elseif !vigor#type#isDict(obj) && !vigor#type#isList(obj)
      return 1
    endif
  endfor
endfunction

function! vigor#dict#set(obj, path, val, ...) abort
  let path = s:NormalizePath(a:path)
  let obj = a:obj
  let out = obj

  for segment in path
    if index(path, segment) == len(path) - 1
      let obj[ segment ] = a:val
    else
      if self.isObject(obj) && !has_key(obj, segment)
        let obj[ segment ] = {}
        let obj = obj[ segment ]
      endif
    endif
  endfor

  return out
endfunction

function! s:NormalizePath(path) abort
  let path = a:path
  if type(path) == g:vigor_types.string
    let path = substitute(path, "'", '', 'g')
    let path = substitute(path, '"', '', 'g')
    let path = substitute(path, '\[', '.', 'g')
    let path = substitute(path, '\]', '', 'g')
    let path = split(path, '\.')
  endif
  return path
endfunction
