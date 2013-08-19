function! LiquidFold()

  let folder = {}


  function! folder._setFoldWords()
    " set defaults if g:liquidfold_words hasn't been defined in .vimrc
    "
    if !exists('g:liquidfold_words')
      let g:liquidfold_words = "comment,raw,if,case,for,tablerow,block"
    endif
  endfunction


  function! folder._markLiquidFolds()
    " define fold regions using foldwords
    "
    let foldwords = '\('.join(split(g:liquidfold_words,","),'\|').'\)'
    let foldstart = '^.*{%\s\?'.foldwords.'.*%}.*$'
    let foldend = '^.*{%\s\?end'.foldwords.'.*%}.*$' 
    let foldcommand = "syn region LiquidFold start='".foldstart."' end='".foldend."' fold transparent keepend extend"
    execute foldcommand
  endfunction


  function! folder.execute()
    " folder's public method for initializing syntax folding
    "
    call folder._setFoldWords()
    call folder._markLiquidFolds()
  endfunction


  " initialize syntax folding
  "
  setlocal foldmethod=syntax
  call folder.execute()
  syn sync fromstart
  
endfunction


" avoid conflicts with other autocommands and automatically fold liquid files
"
augroup ft_liquid
  au!
  au BufNewFile,BufRead *.liquid set filetype=liquid
  au FileType liquid silent! call LiquidFold()
augroup END
