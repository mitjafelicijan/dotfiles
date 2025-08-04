set nocompatible noexrc secure
filetype plugin on

call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'mitjafelicijan/sniper.vim'
	Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

set path+=** laststatus=2 encoding=utf8 spelllang=en_us tabstop=4 shiftwidth=4
set number relativenumber autoindent cursorline ignorecase hlsearch incsearch 
set hidden nowrap nobackup noswapfile noundofile autoread updatetime=300
set backspace=indent,eol,start completeopt=menuone
colorscheme wildcharm

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-q> :copen<cr>
nnoremap <C-b> :CtrlPBuffer<cr>
nnoremap <Leader>q :nohlsearch<cr>
nnoremap <Leader>c :silent call system('ctags --c++-kinds=+p -R .')<CR>
nnoremap <leader>g :vimgrep /<C-r><C-w>/ **/*<CR>:copen<CR>

let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = ''
