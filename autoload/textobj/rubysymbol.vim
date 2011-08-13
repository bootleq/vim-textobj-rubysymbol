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

let s:timeout_length = has('reltime') ?
      \ exists('g:textobj_rubysymbol_timeout_length') ? 
      \   g:textobj_rubysymbol_timeout_length : &timeoutlen : 
      \ 0

let s:SYMBOL_NOT_FOUND = 1
let s:NOT_IMPLEMENTED = 2
let s:TIME_OUT = 3

let s:fail = 0
let s:messages = {
      \   s:SYMBOL_NOT_FOUND : "Can't find a symbol.",
      \   s:NOT_IMPLEMENTED : "This feature is not implement yet.",
      \   s:TIME_OUT : "Can't find a symbol. (timeout)",
      \ }
" }}} script wise variables


" util functions {{{
let s:functions = {}

function s:functions.search_unescaped_in_line(line, char, start_col) dict
  let stop_col = a:start_col
  let line = getline(a:line)

  while 1
    let stop_col = matchend(line, a:char, stop_col)
    if stop_col < 0
      return 0
    endif

    let backslashes = matchstr(line, '\m\\*\ze\%' . stop_col . 'c')
    if strlen(backslashes) % 2 == 0
      return stop_col
    endif
  endwhile
endfunction

function s:functions.search_next_unescaped(char, opener) dict
  call cursor(a:opener["line"], a:opener["col"])

  " Take opener line as special case
  let stop_col = s:functions.search_unescaped_in_line(a:opener["line"], a:char, a:opener["col"] + 1)
  if stop_col != 0
    return [line('.'), stop_col]
  endif

  let stop_at = {"line": a:opener["line"], "col": 0}
  while 1
    let stop_at["line"] = searchpos(printf('\m\%%>%dl%s', stop_at["line"], a:char), 'cnW')[0]

    let stop_col =  s:functions.search_unescaped_in_line(stop_at["line"], a:char, 0)
    if stop_col != 0
      return [stop_at["line"], stop_col]
    endif

    if s:functions.check_timeout()
      return [0, 0]
    endif
  endwhile
endfunction

function s:functions.check_timeout() dict
  if ! has('reltime')
    return 1
  endif

  if str2float(reltimestr(reltime(s:start_search_at, reltime()))) * 1000 > s:timeout_length
    let s:fail = s:TIME_OUT
    return 1
  endif
endfunction

" }}} util functions


" main function {{{
function! s:select(inner)

  let s:start_search_at = has('reltime') ? reltime() : 0

  let s:fail = 0
  let cursor = {
        \   "line" : line('.'),
        \   "col" : col('.'),
        \ }
  let save_cursor = {
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

      if ending["col"] < save_cursor["col"]
        let s:fail = s:SYMBOL_NOT_FOUND
      endif
    endif

  elseif opener["type"] == index(s:opener_types, s:QUOTED)
    let quote = getline(opener["line"])[opener["col"]]
    let s:escape_detected = {"line" : 0, "count" : 0}

    let [ending["line"], ending["col"]] = s:functions.search_next_unescaped(quote, opener)

    if ending["line"] < save_cursor["line"] || (ending["line"] == save_cursor["line"] && ending["col"] < save_cursor["col"])
      let s:fail = s:fail ? s:fail : s:SYMBOL_NOT_FOUND
    endif

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
