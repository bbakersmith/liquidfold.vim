" set defaults if g:liquidfold_words hasn't been defined in .vimrc
"
if !exists('g:liquidfold_words')
  let g:liquidfold_words = "comment,raw,if,case,for,tablerow,block"
endif


" define fold regions using foldwords
"
function! MarkLiquidFolds()
  let foldwords = '\('.join(split(g:liquidfold_words,","),'\|').'\)'
  let foldstart = '^.*{%\s\?'.foldwords.'.*%}.*$'
  let foldend = '^.*{%\s\?end'.foldwords.'.*%}.*$' 
  let foldcommand = "syn region LiquidFold start='".foldstart."' end='".foldend."' fold transparent keepend extend"
  execute foldcommand
endfunction


" initialize syntax folding
"
function! InitLiquidFolds()
  setlocal foldmethod=syntax
  call MarkLiquidFolds()
  syn sync fromstart
endfunction


" avoid conflicts with other liquid autocommands
"
augroup ft_liquid
  au!
  au BufNewFile,BufRead *.liquid set filetype=liquid
  au FileType liquid silent! call InitLiquidFolds()
augroup END
