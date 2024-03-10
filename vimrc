" https://vimhelp.org/options.txt.html

set nocompatible
syntax enable

" Theme.
if has('vim')
  colorscheme wildcharm
endif
set background=dark
hi Normal ctermbg=233

" Sane defaults.
set path+=**
set relativenumber
set smartcase
set ignorecase
set incsearch
set nowrap
set nobackup
set noswapfile
set autoread
set wildmenu
set autoindent
set encoding=utf8
set backspace=2
set scrolloff=4
set spelllang=en_us
set laststatus=2

" Buffer navigation remaps.
nnoremap <C-]> :bnext<cr>
nnoremap <C-[> :bprevious<cr>

" Language specific indentation.
filetype plugin indent on
autocmd Filetype make,go,sh setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd Filetype c,cpp,html,javascript,css,python setlocal expandtab tabstop=2 shiftwidth=2

" Throwaway config.
"au BufReadPost *.twig set syntax=html

