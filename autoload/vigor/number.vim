function! vigor#number#isEven(num) abort
  return fmod(a:num, 2) == 0.0
endfunction

function! vigor#number#isOdd(num) abort
  return fmod(a:num, 2) != 0.0
endfunction
