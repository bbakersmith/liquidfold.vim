function! LiquidFold()


  function! a:_setFoldWords()
    " set defaults if g:liquidfold_words hasn't been defined in .vimrc
    "
    if !exists('g:liquidfold_words')
      let g:liquidfold_words = "comment,raw,if,case,for,tablerow,block"
    endif
  endfunction


  function! a:_markLiquidFolds()
    " define fold regions using a:foldwords
    "
    let a:foldwords = '\('.join(split(g:liquidfold_words,","),'\|').'\)'

    " regexes to find start and end tags
    let a:startmatch = '.*{%\s\?'.a:foldwords
    let a:endmatch = '.*{%\s\?end'.a:foldwords

    " exclude lines with a close tag
    let a:foldstart = '^'.a:startmatch.'.*$'
    " let a:foldstart = '^'.a:startmatch.'\('.a:endmatch.'\)\@!.*$'

    " exclude lines with an open tag
    let a:foldend = '^'.a:endmatch.'.*$'
    " let a:foldend = '^\('.a:startmatch.'\)\@!'.a:endmatch.'.*$'

    " create and execute final command
    let a:foldcommand = "syn region LiquidFold start='".a:foldstart."' end='".a:foldend."' fold transparent keepend extend"

echo a:foldcommand
    execute a:foldcommand
  endfunction


  function! a:execute()
    " initialize syntax folding
    "
    setlocal foldmethod=syntax
    call a:_setFoldWords()
    call a:_markLiquidFolds()
    syn sync fromstart
  endfunction


  call a:execute()

endfunction


" avoid conflicts with other autocommands and automatically fold liquid files
"
augroup ft_liquid
  au!
  au BufNewFile,BufRead *.liquid set filetype=liquid
  au FileType liquid call LiquidFold()
  " au FileType liquid silent! call LiquidFold()
augroup END
