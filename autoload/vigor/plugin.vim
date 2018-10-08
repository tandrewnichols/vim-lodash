function! vigor#plugin#requires(name, deps) abort
  let missing = 0

  for dep in a:deps
    let name = get(split(dep, '/'), -1)
    let guard = "g:loaded_" . substitute(substitute(name, '^vim-', '', ''), '\.vim$', '', '')

    if !exists(guard)
      let missing = 1
      echo a:name "requires" name . ". See" dep . "."
    endif
  endfor

  return missing
endfunction
