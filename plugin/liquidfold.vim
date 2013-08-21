" avoid duplicate autocommands; set filetype for .liquid files and fold them
"
augroup ft_liquid
  au!
  au BufNewFile,BufRead *.liquid set filetype=liquid
  au FileType liquid silent! call liquidfold#Init()
augroup END
