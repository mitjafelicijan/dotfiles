set nocompatible exrc secure
filetype plugin on

call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'mitjafelicijan/sniper.vim'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'dense-analysis/ale'
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
nnoremap <C-k> :ALEHover<cr>
nnoremap <C-j> :ALEDetail<cr>

nmap <silent> gr :ALEFindReferences<cr>
nmap <silent> gd :ALEGoToDefinition<cr>
nmap <silent> re :ALERename<cr>

let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = ''

let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_floating_window_border = 0
let g:ale_virtualtext_cursor = 0
let g:ale_set_quickfix = 1
