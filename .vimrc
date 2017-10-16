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

" Solarized color scheme from https://github.com/altercation/vim-colors-solarized.git
Plugin 'altercation/vim-colors-solarized'
" NERDTree file system navigation
Plugin 'scrooloose/nerdtree'
" Airline status/tabline customization
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Tagbar class outline viewer
Plugin 'majutsushi/tagbar'
" Git wrapper
Plugin 'tpope/vim-fugitive'
" Tmux vim navigation
Plugin 'christoomey/vim-tmux-navigator'
" Latex support
"Plugin 'vim-latex/vim-latex'
" Typescript syntax support
Plugin 'leafgarland/typescript-vim'

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

" Set up tabs spaces
set autoindent
set expandtab
set shiftwidth=2
set tabstop=2

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
