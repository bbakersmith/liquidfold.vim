" set defaults if g:liquid_foldwords hasn't been set in .vimrc
"
if !exists('g:liquid_foldwords')
  let g:liquid_foldwords = "comment,raw,if,case,for,tablerow,block"
endif


" define fold regions using foldwords
"
function! MarkLiquidFolds()
  let foldwords = '\('.join(split(g:liquid_foldwords,","),'\|').'\)'
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
