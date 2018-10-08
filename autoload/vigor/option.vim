function! vigor#option#set(...) abort
  let infer = 0

  if a:0 == 1 && vigor#type#isDict(a:1)
    let infer = 1
    let options = a:1
  elseif a:0 == 2 && vigor#type#isDict(a:2)
    let prefix = a:1
    let options = a:2
  elseif a:0 == 2
    let infer = 1
    let options = { a:1: a:2 }
  elseif a:0 == 3
    let prefix = a:1
    let options = { a:2: a:3 }
  endif

  if infer
    let prefix = vigor#util#caller("<sfile>")
  endif

  for [option, default] in items(options)
    exec "let g:{prefix}_{option} = get(g:, '{prefix}_{option}', default)"
  endfor
endfunction

function! vigor#option#get(prefix) abort
  if a:0 == 1
    let name = a:prefix
  endif
endfunction
