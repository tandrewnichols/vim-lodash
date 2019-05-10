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
      elseif vigor#type#isDict(v)
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
      if vigor#type#isDict(v)
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
  let conflict = a:0 ? a:1 : 'ignore'

  for segment in path
    let idx = index(path, segment)
    if idx == len(path) - 1
      if vigor#type#isDict(obj) || vigor#type#isList(obj)
        let obj[ segment ] = a:val
      elseif conflict == 'throw'
        throw 'vigor#dict#set(): Cannot set property "' . segment . '" of ' . (vigor#type#isNumber(obj) ? obj : '"' . obj . '"')
      elseif conflict != 'ignore'
        throw 'vigor#dict#set(): Unknown argument "' . conflict . '." Valid argument values for conflict handling are "ignore," "throw," and "force."'
      endif
    else
      let next = path[ idx + 1 ]
      let nextIsNum = next =~ '^\d\+$'
      if vigor#type#isDict(obj)
        if !has_key(obj, segment)
          if nextIsNum
            let obj[ segment ] = vigor#list#fill([], next + 1)
          else
            let obj[ segment ] = {}
          endif
        endif
      elseif vigor#type#isList(obj)
        if len(obj) - 1 < segment
          call vigor#list#fill(obj[ segment ], next + 1)
        endif
      endif

      if empty(get(obj, segment))
        let obj[ segment ] = nextIsNum ? vigor#list#fill([], next + 1) : {}
      endif

      if idx + 1 <= len(path) - 1 && !vigor#type#isDict(obj[ segment ]) && !vigor#type#isList(obj[ segment ]) && conflict == 'force'
        let obj[ segment ] = nextIsNum ? vigor#list#fill([], next + 1) : {}
      endif
      let obj = obj[ segment ]
    endif
  endfor

  return obj
endfunction

function! s:NormalizePath(path) abort
  let path = a:path
  if vigor#type#isString(path)
    let path = substitute(path, "'", '', 'g')
    let path = substitute(path, '"', '', 'g')
    let path = substitute(path, '\[', '.', 'g')
    let path = substitute(path, '\]', '', 'g')
    let path = split(path, '\.')
  endif
  return path
endfunction
