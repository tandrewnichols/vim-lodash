function! vigor#map#cremap(lhs, rhs, ...) abort
  let lhs = a:lhs
  let rhs = a:rhs
  let buffer = a:0 && has_key(a:1, 'buffer') ? a:1.buffer : 0
  let mode = a:0 && has_key(a:1, 'mode') ? a:1.mode : [':', '>', '/', '?', '@', '-', '=']
  let position = a:0 && has_key(a:1, 'position') ? a:1.position : 1

  if !empty(mode) && !vigor#type#isList(mode)
    let mode = [mode]
  endif

  if len(mode)
    let rhs = "\<C-R>=(index(" . string(mode) . ", getcmdtype())>-1" . (position ? " && getcmdpos()==" . position : "") . " ? " . string(rhs) . " : " . string(lhs) . ")\<CR>"
  elseif position
    let rhs = "\<C-R=(getcmdpos()==" . position . " ? " . string(rhs) . " : " . string(lhs) . ")\<CR>"
  endif

  exec "cnoreabbrev " . (buffer ? "<buffer>" : "") lhs rhs
endfunction
