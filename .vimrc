filetype plugin indent on
set autoindent
set number "view line numbers"
set background=dark
set tabstop=4 "spaces per tab"
set shiftwidth=4
"treat Jakefiles as JS syntax"
au BufNewFile,BufRead *Jakefile set filetype=javascript
set complete+=k
set dictionary+=~/.dictionary
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

"no arrows!"
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

set listchars=tab:▸▸,trail:- "nicer whitespace chars
set list " show whitespace
set mouse=nv " allow mouse
let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1 

let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
"Close vim if NERDTree is the only open buffer"
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
imap qq <esc>a<Plug>snipMateNextOrTrigger
smap qq <Plug>snipMateNextOrTrigger
"map jj to escape in insert mode"
imap jj <Esc>

set exrc
set secure
