if exists("g:loaded_vigor") || &cp | finish | endif

let g:loaded_vigor = 1
let g:vigor_VERSION = '1.0.0'

let g:vigor_types = {
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
