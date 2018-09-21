function! vigor#number#isEven(num)
  return fmod(a:num, 2) == 0.0
endfunction

function! vigor#number#isOdd(num)
  return fmod(a:num, 2) != 0.0
endfunction
