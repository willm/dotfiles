set number "view line numbers"
set background=dark
set tabstop=4 "spaces per tab"
set shiftwidth=4
"treat Jakefiles as JS syntax"
au BufNewFile,BufRead *Jakefile set filetype=javascript
set complete+=k
set dictionary+=~/.dictionary
filetype plugin indent on
set nobackup "don't create ~ and swp files"

"start nerdtree automatically"
autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p
execute pathogen#infect()
" Enable saving readonly files with sudo"
cmap w!! %!sudo tee > /dev/null %
colorscheme 256-grayvim

"\s shortcut - replace current word"
:nnoremap \s :%s/\<<C-r><C-w>\>/
:nmap <F2> :NERDTreeToggle<CR>

set listchars=tab:▸▸,trail:- "nicer whitespace chars
set list " show whitespace
set mouse=nv " allow mouse
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"Close vim if NERDTree is the only open buffer"
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
imap qq <esc>a<Plug>snipMateNextOrTrigger
smap qq <Plug>snipMateNextOrTrigger
"map jj to escape in insert mode"
imap jj <Esc>
