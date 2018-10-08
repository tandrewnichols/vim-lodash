function! vigor#util#caller(sfile) abort
  let scriptnum = matchstr(expand(a:sfile), '<SNR>\zs\d\+\ze')
  echo scriptnum
  let scripts = vigor#util#capture('silent! scriptnames')
  return fnamemodify(matchstr(scripts, scriptnum . ': \zs\f\+\ze'), ':t:r')
endfunction

function! vigor#util#capture(cmds) abort
  let cmds = vigor#type#isList(a:cmds) ? a:cmds : [ a:cmds ]

  redir => output

  for cmd in cmds
    exec cmd
  endfor

  redir END

  return output
endfunction
