" set defaults if g:liquidfold_words hasn't been defined in .vimrc
"
function! s:_getFoldWords()
  if exists('g:liquidfold_words')
    return g:liquidfold_words
  else
    return "comment,raw,if,case,for,tablerow,block"
  endif
endfunction


" define fold regions
"
function! s:_markFolds()
  " format fold words into regex 'or' block
  let words = s:_getFoldWords()
  let foldwords = '\('.join(split(words,","),'\|').'\)'

  " regexes to find start and end tags
  let startmatch = '.*{%\s\?'.foldwords
  let endmatch = '.*{%\s\?end'.foldwords

  " exclude lines with both an open and close tag
  let foldstart = '^'.startmatch.'\('.endmatch.'\)\@!.*$'
  let foldend = '^\('.startmatch.'\)\@!'.endmatch.'.*$'

  " create and execute command string
  let foldcommand = "syn region LiquidFold start='".foldstart."' end='".foldend."' fold transparent keepend extend"
  execute foldcommand
endfunction


" initialize syntax folding
"
function! liquidfold#Init()
  setlocal foldmethod=syntax
  call s:_markFolds()
  syn sync fromstart
endfunction
