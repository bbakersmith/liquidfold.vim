function! LiquidFold()

  " set defaults if g:liquidfold_words hasn't been defined in .vimrc
  "
  function! a:_setFoldWords()
    if !exists('g:liquidfold_words')
      let g:liquidfold_words = "comment,raw,if,case,for,tablerow,block"
    endif
  endfunction


  " define fold regions
  "
  function! a:_markFolds()
    " format foldwords into regex 'or' block
    let a:foldwords = '\('.join(split(g:liquidfold_words,","),'\|').'\)'

    " regexes to find start and end tags
    let a:startmatch = '.*{%\s\?'.a:foldwords
    let a:endmatch = '.*{%\s\?end'.a:foldwords

    " exclude lines with both an open and close tag
    let a:foldstart = '^'.a:startmatch.'\('.a:endmatch.'\)\@!.*$'
    let a:foldend = '^\('.a:startmatch.'\)\@!'.a:endmatch.'.*$'

    " create and execute final command
    let a:foldcommand = "syn region LiquidFold start='".a:foldstart."' end='".a:foldend."' fold transparent keepend extend"
    execute a:foldcommand
  endfunction


  " initialize syntax folding
  "
  function! a:execute()
    setlocal foldmethod=syntax
    call a:_setFoldWords()
    call a:_markFolds()
    syn sync fromstart
  endfunction


  call a:execute()

endfunction


" avoid duplicate autocommands; set filetype for .liquid files and fold them
"
augroup ft_liquid
  au!
  au BufNewFile,BufRead *.liquid set filetype=liquid
  au FileType liquid silent! call LiquidFold()
augroup END
