set nocompatible exrc secure
filetype plugin on

call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'mitjafelicijan/sniper.vim'
	Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

set encoding=utf8 spelllang=en_us laststatus=2 tabstop=4 shiftwidth=4
set number autoindent cursorline ignorecase hlsearch incsearch
set hidden nowrap nobackup noswapfile noundofile autoread updatetime=300
set backspace=indent,eol,start completeopt=menuone
set path+=** wildignore+=tags,*.o,*.a,*.so
colorscheme wildcharm

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-q> :copen<cr>
nnoremap <C-b> :CtrlPBuffer<cr>
nnoremap <Leader>q :nohlsearch<cr>
nnoremap <Leader>c :silent call system('ctags --c++-kinds=+p -R .')<CR>
nnoremap <leader>w :vimgrep /<C-r><C-w>/gj **/*<CR>:copen<CR>

let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = ''
