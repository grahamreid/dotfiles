
filetype plugin indent on

set tabstop=4
set shiftwidth=4
set expandtab

"Automatic install / double check of vim-plug

if empty(glob('~/.vim/autoload/plug.vim'))

  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC

endif

call plug#begin()

Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
" Plug 'Valloric/YouCompleteMe'

call plug#end()

colorscheme molokai

let g:fzf_colors = { 'hl': ['fg', 'Comment'] }

set incsearch           " search as characters are entered
set hlsearch            " highlight matches

nnoremap <CR> :nohlsearch<CR><CR>

set wildmenu            " visual autocomplete for command menu
set ruler               " show line and column number of the cursor on right side of statusline
set lazyredraw          " redraw screen only when we need to
set showmatch           " highlight matching parentheses / brackets [{()}]


