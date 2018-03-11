if exists("g:loaded_lodash") || &cp | finish | endif

let g:loaded_lodash = 1

let _ = { 'VERSION': '0.0.1' }

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

function! _.extend(dest, ...)
  let srcs = a:000
  for src in srcs
    call extend(a:dest, src)
  endfor

  return a:dest
endfunction

function! _.defaults(dest, ...)
  let srcs = a:000
  for src in srcs
    call extend(a:dest, src, 'keep')
  endfor

  return a:dest
endfunction

function! _.defaultsDeep(dest, ...)
  let srcs = a:000
  for src in srcs
    for [k,v] in items(src)
      if !has_key(a:dest, k)
        let a:dest[k] = deepcopy(src[k])
      elseif type(v) == s:types.dict
        call self.defaultsDeep(a:dest[k], v)
      endif
    endfor
  endfor

  return a:dest
endfunction

function! _.merge(dest, ...)
  let srcs = a:000
  for src in srcs
    for [k,v] in items(src)
      if type(v) == s:types.dict
        let a:dest[k] = self.merge(a:dest[k], v)
      else
        let a:dest[k] = v
      endif
    endfor
  endfor

  return a:dest
endfunction

function! _.upperFirst(thing)
  return substitute(a:thing, '^\([a-z]\)', '\U\1', '')
endfunction

function! _.includes(str, pat)
  return match(a:str, a:pat) > -1
endfunction

function! _.find(list, predicate)
  return s:findByObj(a:list, a:predicate)
endfunction

function! _.findIndex(list, predicate)
  let obj = s:findByObj(a:list, a:predicate)
  if type(obj) == s:types.dict
    return index(a:list, obj)
  else
    return -1
  endif
endfunction

function! s:findByObj(list, predicate)
  for item in a:list
    let found = 1
    for key in keys(a:predicate)
      if item[ key ] != a:predicate[ key ]
        let found = 0
        break
      endif
    endfor

    if found
      return item
    endif
  endfor

  return -1
endfunction

function! _.trim(str)
  return substitute(substitute(a:str, '^ \+', '', ''), ' \+$', '', '')
endfunction

function! _.pad(str, len, ...)
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

function! _.padStart(str, len, ...)
  let sep = a:0 == 1 ? a:1 : ' '
  if len(a:str) < a:len
    let padding = repeat(sep, a:len - len(a:str))
    return padding . a:str
  else
    return a:str
  endif
endfunction

function! _.padEnd(str, len, ...)
  let sep = a:0 == 1 ? a:1 : ' '
  if len(a:str) < a:len
    let padding = repeat(sep, a:len - len(a:str))
    return a:str . padding
  else
    return a:str
  endif
endfunction

function! _.isEven(num)
  return fmod(a:num, 2) == 0.0
endfunction

function! _.isOdd(num)
  return fmod(a:num, 2) != 0.0
endfunction

function! _.sortBy(list, field)
  if has_key(a:list[0], a:field)
    if type(a:list[0][a:field]) == s:types.number
      return self.sortNumeric(a:list, a:field)
    else
      return self.sortAlpha(a:list, a:field)
    endif
  else
    return a:list
  endif
endfunction

function! _.sortAlpha(list, field)
  let field = a:field
  let list = copy(a:list)

  function! s:SortAlpha(first, second) closure
    let a = a:first[ field ]
    let b = a:second[ field ]

    if a == b
      return 0
    endif

    let sorted = sort([a, b])
    if sorted[0] == a
      return -1
    endif

    return 1
  endfunction

  return sort(list, 's:SortAlpha')
endfunction

function! _.sortNumeric(list, prop)
  function! s:SortNumeric(a, b) closure
    let a = a:a[ a:prop ] + 0
    let b = a:b[ a:prop ] + 0

    if a < b
      return -1
    elseif a == b
      return 0
    else
      return 1
    endif
  endfunction

  return sort(a:list, function('s:SortNumeric'))
endfunction

function! _.map(list, predicate)
  let list = copy(a:list)
  if type(a:predicate) == s:types.function
    return map(list, a:predicate)
  elseif type(a:predicate) == s:types.string
    let predicate = 'v:val.' . a:predicate
    return map(list, predicate)
  endif
endfunction

function! _.reduce(list, fn, memo)
  let Iteree = a:fn
  let memo = a:memo
  let list = copy(a:list)

  for item in list
    let memo = Iteree(memo, item, index(list, item), list)
  endfor

  return memo
endfunction

function! _.get(obj, path, ...)
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

function! _.has(obj, path)
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

function! _.set(obj, path, val)
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

function! s:NormalizePath(path)
  let path = a:path
  if type(path) == s:types.string
    let path = substitute(path, "'", '', 'g')
    let path = substitute(path, '"', '', 'g')
    let path = substitute(path, '\[', '.', 'g')
    let path = substitute(path, '\]', '', 'g')
    let path = split(path, '\.')
  endif
  return path
endfunction

function! _.isNumber(thing)
  return type(a:thing) == s:types.number
endfunction

function! _.isString(thing)
  return type(a:thing) == s:types.string
endfunction

function! _.isFunction(thing)
  return type(a:thing) == s:types.function
endfunction

function! _.isFuncref(thing)
  return type(a:thing) == s:types.function
endfunction

function! _.isArray(thing)
  return type(a:thing) == s:types.list
endfunction

function! _.isList(thing)
  return type(a:thing) == s:types.list
endfunction

function! _.isObject(thing)
  return type(a:thing) == s:stypes.dict
endfunction

function! _.isDict(thing)
  return type(a:thing) == s:stypes.dict
endfunction
