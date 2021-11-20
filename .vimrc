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

autocmd FileType c,cpp,cmake,java,python setlocal et ts=4 st=4 sw=4
autocmd FileType shell,vim,json,yaml,js,html setlocal et ts=2 st=2 sw=2
autocmd FileType go setlocal ts=4 st=4 sw=4

autocmd InsertLeave *.go,*.sh,*.py,*.c,*.cpp,*.cmake write

let g:mapleader=","

call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'h1zzz/what.vim'
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug'] }
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'vim-python/python-syntax'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

augroup nerdtreehidepath
  autocmd!
  autocmd FileType nerdtree setlocal conceallevel=3
        \ | syntax match NERDTreeHidePath #^[</].*$# conceal
        \ | setlocal concealcursor=nvi
augroup end

colorscheme what

let g:go_fmt_autosave=0
let g:go_fmt_fail_silently=0
let g:go_imports_autosave=0
let g:go_mod_fmt_autosave=0
let g:go_doc_keywordprg_enabled=0
let g:go_def_mapping_enabled=0
let g:go_search_bin_path_first=0
let g:go_textobj_enabled=0
let g:go_textobj_include_variable=0
let g:go_gopls_enabled=0
let g:go_template_autocreate=0

let g:go_highlight_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_function_calls=1
let g:go_highlight_operators=1
let g:go_highlight_extra_types=1
let g:go_highlight_methods=1
let g:go_highlight_generate_tags=1

let g:python_highlight_all=1

let g:NERDTreeWinSize=40
let g:NERDSpaceDelims=1
let g:NERDTreeMinimalUI=1
let g:NERDAltDelims_python=1
let g:NERDTreeStatusline=-1
let g:NERDTreeShowHidden=1
let NERDTreeShowHidden=1

let g:coc_global_extensions=['coc-clangd', 'coc-go', 'coc-cmake', 'coc-json', 'coc-pyright', 'coc-sh']

nmap <F1> <ESC>
imap <F1> <ESC>

nmap <F2> :NERDTreeToggle<CR>
nmap <F3> :TagbarToggle<CR>
nmap ; :

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
call coc#config('clangd.semanticHighlighting', v:true)
call coc#config('coc.preferences.semanticTokensHighlights', v:false)

