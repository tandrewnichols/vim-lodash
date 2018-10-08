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
  let srcs = a:000
  for src in srcs
    for [k,v] in items(src)
      if !has_key(a:dest, k)
        let a:dest[k] = deepcopy(src[k])
      elseif type(v) == g:vigor_types.dict
        call self.defaultsDeep(a:dest[k], v)
      endif
    endfor
  endfor

  return a:dest
endfunction

function! vigor#dict#merge(dest, ...) abort
  let srcs = a:000
  for src in srcs
    for [k,v] in items(src)
      if type(v) == g:vigor_types.dict
        let a:dest[k] = self.merge(a:dest[k], v)
      else
        let a:dest[k] = v
      endif
    endfor
  endfor

  return a:dest
endfunction

function! vigor#dict#get(obj, path, ...) abort
  let default = a:0 == 1 ? a:1 : 0
  let path = s:NormalizePath(a:path)
  let obj = a:obj
  for segment in path
    if (self.isObject(obj) && has_key(obj, segment)) || (self.isArray(obj) && len(obj) + 1 >= segment)
      if self.isObject(obj[ segment  ]) || self.isArray(obj[ segment ])
        let obj = obj[ segment ]
      else
        return obj[ segment ]
      endif
    else
      return default
    endif
  endfor
endfunction

function! vigor#dict#has(obj, path) abort
  let path = s:NormalizePath(a:path)
  let obj = a:obj
  for segment in path
    if (self.isObject(obj) && has_key(obj, segment)) || (self.isArray(obj) && len(obj) + 1 >= segment)
      if self.isObject(obj[ segment  ]) || self.isArray(obj[ segment ])
        let obj = obj[ segment ]
      else
        return exists('obj[ segment ]')
      endif
    else
      return 0
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
