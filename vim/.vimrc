" Fix slowdown when switching tmux sessions
set shell=/bin/bash\ -i

" Turn of vi improvements
set nocompatible
filetype off

" Vundle Plugin management
" https://github.com/VundleVim/Vundle.vim
"
" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#being('~/some/path/here')

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

""""""""""""""""""""""""
" Editor Appearance    "
""""""""""""""""""""""""
" Solarized color scheme from https://github.com/altercation/vim-colors-solarized.git
Plugin 'altercation/vim-colors-solarized'
Plugin 'pineapplegiant/spaceduck'
Plugin 'dikiaap/minimalist'
Plugin 'ghifarit53/tokyonight-vim'
Plugin 'joshdick/onedark.vim'
Plugin 'sainnhe/sonokai'
" Airline status/tabline customization
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Tagbar class outline viewer
Plugin 'majutsushi/tagbar'

""""""""""""""""""""""""
" Editor Functionality "
""""""""""""""""""""""""
" Language pack for synatx support
Plugin 'sheerun/vim-polyglot'
" Ranger file system navigation
Plugin 'francoiscabrol/ranger.vim'
" NERDTree file system navigation
Plugin 'scrooloose/nerdtree'
" Better commenting (gc/gcc)
Plugin 'tpope/vim-commentary'
" Git wrapper
Plugin 'tpope/vim-fugitive'
" Easily change quotes and tags
Plugin 'tpope/vim-surround'
" Change opening and closing tags at the same time
Plugin 'AndrewRadev/tagalong.vim'
" Tmux vim navigation
Plugin 'christoomey/vim-tmux-navigator'
" Fuzzy search
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Linting
Plugin 'dense-analysis/ale'
" Vim Magit
Plugin 'jreybert/vimagit'

""""""""""""""""""""""""
" Application Specific "
""""""""""""""""""""""""
" Latex support
"Plugin 'vim-latex/vim-latex'
" Better markdown/note taking
"Plugin 'sidofc/mkdx'
" GLSL/Shader support
Plugin 'tikhomirov/vim-glsl'

" All Plugins before this line
call vundle#end()
filetype plugin indent on
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
"
" To install Plugins,
"    launch vim and run :PluginInstall
"    or from command line: vim +PluginInstall +qall
" Non-Plugin stuff after this line

syntax on
set shell=bash
set fileformats=unix
set ttyfast
set scrolloff=5

" Settings for tagbar
set showmode
set showcmd
set wildmenu
set ruler
set laststatus=2

" Smarter searching
set ignorecase
set smartcase
set hls
"set cursorline
" Maps CTRL+L to turn off highlight search
"nnoremap <silent> <C-l> :nohl<CR><C-l>

" Set column width, color and line numbers
"set textwidth=79
"set colorcolumn=80
set nu
set termguicolors
" colorscheme minimalist
" colorscheme spaceduck
colorscheme onedark
" colorscheme tokyonight
" let g:tokyonight_style = 'storm' " available: night, storm
" let g:tokyonight_enable_italic = 1

" let g:airline_theme='minimalist'
" let g:airline_theme='spaceduck'
let g:airline_theme='onedark'
" let g:airline_theme='tokyonight'

" Set up tabs spaces
set autoindent
set expandtab
set shiftwidth=2
set tabstop=2

" Make window splitting more natural
set splitright
set splitbelow

" Show trailing whitespace
set list listchars=tab:»·,trail:·

" Alternate Keybindings
" Easier insert exit
imap jk <ESC>
imap kj <ESC>

" Easier split pane navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Modify tab spacing to 4 spaces when editing python files
function PySpacesCfg()
  set expandtab
  set tabstop=8
  set softtabstop=4
  set shiftwidth=4
endfunction
:autocmd FileType python :call PySpacesCfg()

" Buffer toggles
nmap M :NERDTreeToggle<CR>
nmap T :TagbarToggle<CR>
nmap <M-p> :TagbarToggle<CR>

" Searching
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
nnoremap <silent> <c-F> :Rg<CR>
nnoremap <silent> <c-p> :Files<CR>

" Linting configuration
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier', 'eslint'],
\   'jsx': ['prettier', 'eslint'],
\}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
