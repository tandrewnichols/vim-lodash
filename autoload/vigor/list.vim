function! vigor#list#find(list, predicate)
  return s:findByObj(a:list, a:predicate)
endfunction

function! vigor#list#findIndex(list, predicate)
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

function! vigor#list#sortBy(list, field)
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

function! vigor#list#sortAlpha(list, field)
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

function! vigor#list#sortNumeric(list, prop)
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

function! vigor#list#map(list, predicate)
  let list = copy(a:list)
  if type(a:predicate) == s:types.function
    return map(list, a:predicate)
  elseif type(a:predicate) == s:types.string
    let predicate = 'v:val.' . a:predicate
    return map(list, predicate)
  endif
endfunction

function! vigor#list#reduce(list, fn, memo)
  let Iteree = a:fn
  let memo = a:memo
  let list = copy(a:list)

  for item in list
    let memo = Iteree(memo, item, index(list, item), list)
  endfor

  return memo
endfunction
