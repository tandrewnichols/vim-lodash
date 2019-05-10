function! vigor#list#find(list, predicate, ...) abort
  let predicate = a:predicate
  let list = a:list
  let args = a:0 > 0 ? a:1 : 3

  if vigor#type#isDict(predicate)
    return s:findByObj(list, predicate)
  elseif vigor#type#isFunction(predicate)
    return s:findByFunc(list, predicate, args)
  elseif vigor#type#isString(predicate)
    return s:findByFunc(list, function(predicate), args)
  endif
endfunction

function! vigor#list#findIndex(list, predicate, ...) abort
  let args = a:0 > 0 ? a:1 : 3
  let res = vigor#list#find(a:list, a:predicate, args)

  if res == v:null
    return -1
  else
    return index(a:list, res)
  endif
endfunction

function! s:findByObj(list, predicate) abort
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

  return v:null
endfunction

function! s:findByFunc(list, function, args) abort
  let Predicate = a:function
  let args = a:args
  for item in a:list
    let i = index(a:list, item)

    if args == 1
      let res = Predicate(item)
    elseif args == 2
      let res = Predicate(item, i)
    else
      let res = Predicate(item, i, a:list)
    endif

    if res
      return item
    endif
  endfor

  return v:null
endfunction

function! vigor#list#sortBy(list, field) abort
  if has_key(a:list[0], a:field)
    if vigor#type#isNumber(a:list[0][a:field])
      return vigor#list#sortNumeric(a:list, a:field)
    else
      return vigor#list#sortAlpha(a:list, a:field)
    endif
  else
    return a:list
  endif
endfunction

function! vigor#list#sortAlpha(list, field) abort
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

function! vigor#list#sortNumeric(list, prop) abort
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

function! vigor#list#map(list, predicate) abort
  let list = copy(a:list)
  if vigor#type#isFunction(a:predicate)
    return map(list, a:predicate)
  elseif vigor#type#isString(a:predicate)
    let predicate = 'v:val.' . a:predicate
    return map(list, predicate)
  endif
endfunction

function! vigor#list#reduce(list, fn, memo) abort
  let Iteree = a:fn
  let memo = a:memo
  let list = copy(a:list)

  for item in list
    let memo = Iteree(memo, item, index(list, item), list)
  endfor

  return memo
endfunction

function! vigor#list#fill(list, num, ...) abort
  let val = a:0 == 0 ? v:null : a:1
  let list = a:list
  let num = a:num

  if len(list) == 0
    call add(list, val)
  endif

  if num > 1
    let list = repeat(list, num)
  endif

  return list
endfunction
