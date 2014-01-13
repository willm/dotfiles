set number "view line numbers"
set background=dark
set tabstop=4 "spaces per tab"
set shiftwidth=4
"treat Jakefiles as JS syntax"
au BufNewFile,BufRead *Jakefile set filetype=javascript
colorscheme desert
set complete+=k
set dictionary+=~/.dictionary
filetype plugin indent on
set nobackup "don't create ~ and swp files"

"start nerdtree automatically"
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
execute pathogen#infect()
" Enable saving readonly files with sudo
cmap w!! %!sudo tee > /dev/null %
