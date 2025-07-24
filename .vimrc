set nocompatible

call plug#begin()
  Plug 'tpope/vim-commentary'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'dense-analysis/ale'
  Plug 'airblade/vim-gitgutter'
call plug#end()

set laststatus=2 encoding=utf8 spelllang=en_us tabstop=4 shiftwidth=4 path=**
set number relativenumber autoindent cursorline ignorecase signcolumn=yes
set hidden nowrap nobackup noswapfile noundofile autoread updatetime=300
set hlsearch incsearch
colorscheme wildcharm

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-q> :copen<cr>
nnoremap <C-b> :CtrlPBuffer<cr>
nnoremap <Leader>e :nohlsearch<cr>
nnoremap <Leader>q :ALEHover<cr>
nnoremap <Leader>w :ALEDetail<cr>

nmap <silent> gr :ALEFindReferences<cr>
nmap <silent> gd :ALEGoToDefinition<cr>
nmap <silent> re :ALERename<cr>

let g:ctrlp_use_caching = 0
let g:ale_completion_enabled = 0
let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_virtualtext_cursor = 0
let g:ale_set_quickfix = 1
let g:ale_linters = { 'c': ['clangd'], 'cpp': ['clangd'] }
