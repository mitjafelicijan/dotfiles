call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'dense-analysis/ale'
	Plug 'airblade/vim-gitgutter'
	Plug 'mitjafelicijan/sniper.vim'
call plug#end()

set nocompatible encoding=utf8 spelllang=en_us laststatus=2 tabstop=4 shiftwidth=4
set number autoindent cursorline ignorecase hlsearch incsearch signcolumn=yes
set hidden nowrap nobackup noswapfile noundofile autoread
set background=dark

syntax on
filetype plugin on
colorscheme wildcharm

nnoremap <C-Right>  :bnext<CR>
nnoremap <C-Left>   :bprevious<CR>
nnoremap <C-q>      :copen<CR>
nnoremap <C-b>      :CtrlPBuffer<CR>
nnoremap <Leader>d  :bd!<CR>
nnoremap <Leader>q  :nohlsearch<CR>

nnoremap <C-k>      :ALEHover<CR>
nnoremap <C-j>      :ALEDetail<CR>
nnoremap <C-Up>     :ALEPrevious<CR>
nnoremap <C-Down>   :ALENext<CR>
nmap <silent> gr    :ALEFindReferences -quickfix<CR>:sleep 100m<CR>:copen<CR>
nmap <silent> gd    :ALEGoToDefinition<CR>
nmap <silent> re    :ALERename<CR>
imap <C-n>          <Plug>(ale_complete)

let g:ctrlp_use_caching = 0
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_floating_window_border = 0
let g:ale_virtualtext_cursor = 0
let g:ale_set_quickfix = 1
