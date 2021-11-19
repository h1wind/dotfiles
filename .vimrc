" MIT License Copyright (c) 2021 h1zzz

noh

filetype on
filetype plugin on
filetype indent on

set nocompatible
set syntax=on
set t_Co=256
set laststatus=2
set encoding=utf-8
set hidden
set backspace=2
set cul
set rnu
set autoread
set completeopt=preview,menu
set nobackup
set nowritebackup
set indentexpr=
set ruler
set noeb
set cino=>4:0l1g0t0(0
set noswapfile
set hlsearch
set incsearch
set showmatch
set matchtime=1
set pumheight=20
set pumwidth=20
set updatetime=300

autocmd FileType c,cpp,cmake,java,python,shell setlocal et ts=4 st=4 sw=4
autocmd FileType json,yaml,js,html setlocal et ts=2 st=2 sw=2
autocmd FileType go setlocal ts=4 st=4 sw=4

let g:mapleader=","

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'h1zzz/what.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

colorscheme what

let g:NERDTreeWinSize=40
let g:NERDSpaceDelims=1
let g:NERDAltDelims_python=1

let g:coc_global_extensions=['coc-clangd', 'coc-cmake', 'coc-go', 'coc-json', 'coc-pyright', 'coc-sh']

map <F1> <NOP>

nmap <F2> :NERDTreeToggle<CR>
nmap <F3> :TagbarToggle<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> K :call <SID>show_documentation()<CR>

imap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<TAB>" : coc#refresh()
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
imap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

command! -nargs=0 Format :call CocAction('format')

call coc#config('diagnostic.enable', v:false)

