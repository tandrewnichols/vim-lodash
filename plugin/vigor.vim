if exists("g:loaded_vigor") || &cp | finish | endif

let g:loaded_vigor = 1
let g:vigor_VERSION = '1.0.0'

let g:vigor_types = {
  \   'number': type(0),
  \   'string': type(''),
  \   'function': type(function('tr')),
  \   'list': type([]),
  \   'dict': type({}),
  \   'float': type(0.0),
  \   'bool': type(v:false),
  \   'none': type(v:none),
  \   'job': 8,
  \   'channel': 9
  \ }
