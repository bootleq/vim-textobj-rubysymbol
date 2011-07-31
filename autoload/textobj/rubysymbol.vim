" Interface  {{{
function! textobj#rubysymbol#select_a()
  return s:select(0)
endfunction

function! textobj#rubysymbol#select_i()
  return s:select(1)
endfunction
" }}} Interface


" script wise variables   {{{
let s:literal_symbol_pattern = join([
      \   ':\v((',
      \     '(\@{1,2}|\$+)\h\w*)',
      \     '|',
      \     '\h\w*[?!=]?',
      \     '|',
      \     '\$\-?.',
      \   ')'
      \ ], '')

let s:LITERAL = '\m[\]})\"'':]\@<!\v:[^"'':]'
let s:QUOTED  = '\m[\]})\"'':]\@<!\v:["'']'

let s:opener_types = [
      \   s:LITERAL,
      \   s:QUOTED,
      \ ]
let s:opener_pattern = '\v(' . join(s:opener_types, ')|(') . ')'
let s:FNAME_PATTERN = ':\v%(' . join([
      \   '[|^&]',
      \   '\<\=\>',
      \   '\={2,3}',
      \   '\=\~',
      \   '\>[\>\=]?',
      \   '\<[\<\=]?',
      \   '[+\-]\@',
      \   '\*\*',
      \   '[+\-\*/%]',
      \   '\~',
      \   '`',
      \   '\[\]\=?',
      \ ], '|') . ')'

let s:SYMBOL_NOT_FOUND = 1
let s:NOT_IMPLEMENTED = 2

let s:fail = 0
let s:messages = {
      \   s:SYMBOL_NOT_FOUND : "Can't find a symbol.",
      \   s:NOT_IMPLEMENTED : "This feature is not implement yet.",
      \ }
" }}} script wise variables


" main function {{{
function! s:select(inner)

  let s:fail = 0
  let cursor = {
        \   "line" : line('.'),
        \   "col" : col('.'),
        \ }
  let opener = {
        \   "line" : 0,
        \   "col" : 0,
        \   "pattern" : 0,
        \ }
  let ending = {
        \   "line" : 0,
        \   "col" : 0,
        \   "pattern" : 0,
        \ }

  let [opener["line"], opener["col"], submatch] = searchpos(s:opener_pattern, 'bcnpW')
  let opener["type"] = submatch - 2
  unlet submatch

  if opener["type"] == index(s:opener_types, s:LITERAL)
    if opener["line"] != cursor["line"]
      let s:fail = s:SYMBOL_NOT_FOUND
    else
      let ending["line"] = cursor["line"]
      let ending["col"] = matchend(getline(cursor["line"]), s:literal_symbol_pattern, opener["col"] - 1)

      if ending["col"] < 0
        let ending["col"] = matchend(getline(cursor["line"]), s:FNAME_PATTERN, opener["col"] - 1)
      endif

      if ending["col"] < cursor["col"]
        let s:fail = s:SYMBOL_NOT_FOUND
      endif
    endif
  elseif opener["type"] == index(s:opener_types, s:QUOTED)
    " TODO implement this
    let s:fail = s:NOT_IMPLEMENTED
  else
    let s:fail = s:SYMBOL_NOT_FOUND
  endif

  if s:fail
    redraw
    echohl WarningMsg | echomsg s:messages[s:fail] | echohl None
    return 0
  else
    if a:inner
      let opener["col"] += 1
    endif

    return ['v',
          \ [0, opener["line"], opener["col"], 0],
          \ [0, ending["line"], ending["col"], 0],
          \ ]
  endif
endfunction
" }}} main function


" END  {{{
" vim: expandtab softtabstop=2 shiftwidth=2
" vim: foldmethod=marker
