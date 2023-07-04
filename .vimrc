set number "view line numbers"
set expandtab
set background=dark
set tabstop=4 "spaces per tab"
set shiftwidth=4
"treat Jakefiles as JS syntax"
au BufNewFile,BufRead *Jakefile set filetype=javascript
"treat handlebars as html"
au BufNewFile,BufRead *.handlebars set filetype=html
set complete+=k
set dictionary+=~/.dictionary
set nobackup "don't create ~ and swp files"
set backspace=indent,eol,start

let NERDTreeIgnore=['.pyc$']
set wildignore+=*.pyc
"start nerdtree automatically"
autocmd VimEnter * wincmd p
execute pathogen#infect()
" Enable saving readonly files with sudo"
cmap w!! %!sudo tee > /dev/null %
colorscheme wombat256

"\s shortcut - replace current word"
:nnoremap \s :%s/\<<C-r><C-w>\>/
:map <F2> :NERDTreeToggle<CR>

"easily switch between buffers influenced by unimpaired"
:nmap [b :bp<CR>
:nmap ]b :bn<CR>
"list buffers and select active one"
:nmap :bl :ls<CR>:b
set hidden "allow hidden buffers"

"no arrows!"
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

noremap <C-p> :FZF<CR>

set colorcolumn=80 " Show 80 char column in light grey
highlight ColorColumn ctermbg=236

set listchars=tab:▸▸,trail:- "nicer whitespace chars
set list " show whitespace
set mouse=nv " allow mouse

"search case insensitive unless caps"
set ignorecase
set smartcase
filetype plugin indent on
"set term=xterm-256color
syntax on
set autoindent

let g:syntastic_auto_jump = 1
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1 

let g:ctrlp_user_command = 'find %s -type f | grep -v node_modules/ | grep -v env/ | grep -v ".git/" | grep -v ".pyc"'

"Close vim if NERDTree is the only open buffer"
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
imap qq <esc>a<Plug>snipMateNextOrTrigger
smap qq <Plug>snipMateNextOrTrigger
"map jj to escape in insert mode"
imap jj <Esc>

let g:neoformat_try_node_exe = 1
"autocmd BufWritePre *.js,*.ts Neoformat

autocmd FileType typescript setlocal formatprg=prettier\ --parser\ typescript

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" leader is \
nmap <leader>rn <Plug>(coc-rename)
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')

set rtp+=/usr/local/opt/fzf

set exrc
set secure
