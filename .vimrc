" Install
"
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" curl -fLo ~/.vimrc https://raw.githubusercontent.com/h1wind/dotfiles/main/.vimrc
"
" Open vim and run: PlugInstall
"

call plug#begin()
Plug 'preservim/nerdcommenter'
Plug 'preservim/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'morhetz/gruvbox'
call plug#end()

let mapleader=","

let g:NERDDefaultAlign = "left"
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDSpaceDelims = 1
let g:NERDAltDelims_python = 1

nmap ; :
nmap <F2> :NERDTreeToggle<CR>

colorscheme gruvbox

autocmd FileType c setlocal ts=4 sw=4
autocmd FileType cpp setlocal ts=4 sw=4
autocmd FileType python setlocal ts=4 sw=4
autocmd FileType java setlocal ts=4 sw=4

autocmd FileType sh setlocal ts=2 sw=2
autocmd FileType vim setlocal ts=2 sw=2
autocmd FileType json setlocal ts=2 sw=2
autocmd FileType cmake setlocal ts=2 sw=2
autocmd FileType yaml setlocal ts=2 sw=2
autocmd FileType html setlocal ts=2 sw=2
autocmd FileType javascript setlocal ts=2 sw=2
autocmd FileType css setlocal ts=2 sw=2

autocmd FileType go setlocal ts=4 sw=4 et
autocmd FileType make setlocal ts=4 sw=4 et

noh

filetype on
filetype plugin on
filetype indent on

set background=dark
set fileformat=unix
set nocompatible
set syntax=on
set t_Co=256
set laststatus=2
set encoding=utf-8
set hidden
set backspace=2
set cul
set nu
set autoread
set completeopt=preview,menu
set nobackup
set nowritebackup
set indentexpr=
set ruler
set noeb
set cino=:0l1g0t0(0
set noswapfile
set hlsearch
set incsearch
set showmatch
set matchtime=1
set pumheight=20
set pumwidth=20
set updatetime=300
set ignorecase
set endofline
set ts=4
set sw=4
set et
