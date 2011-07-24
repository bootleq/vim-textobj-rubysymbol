if exists('g:loaded_textobj_rubysymbol')
  finish
endif


" Interface {{{
call textobj#user#plugin('rubysymbol', {
      \   '-': {
      \     'select-a': 'as', '*select-a-function*': 'textobj#rubysymbol#select_a',
      \     'select-i': 'is', '*select-i-function*': 'textobj#rubysymbol#select_i',
      \   }
      \ })
" }}} Interface


" finish  {{{
let g:loaded_textobj_rubysymbol = 1
" }}} finish


" __END__
" vim: foldmethod=marker
