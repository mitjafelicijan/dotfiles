call plug#begin()
  Plug 'tpope/vim-commentary'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'dense-analysis/ale'
  Plug 'mitjafelicijan/ungabunga'
call plug#end()

set nocompatible laststatus=2 encoding=utf8 spelllang=en_us
set number relativenumber autoindent signcolumn=yes cursorline ignorecase
set hidden nowrap nobackup noswapfile noundofile autoread updatetime=300
colorscheme ungabunga

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-q> :copen<cr>
nnoremap <C-b> :CtrlPBuffer<cr>
nnoremap <C-k> :ALEHover<cr>
nnoremap <C-j> :ALEDetail<cr>
nnoremap <Leader>r :let @/ = ''<CR>

nmap <silent> gr :ALEFindReferences<cr>
nmap <silent> gd :ALEGoToDefinition<cr>
nmap <silent> re :ALERename<cr>

let g:ale_completion_enabled = 0
let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_virtualtext_cursor = 0
let g:ale_set_quickfix = 1
let g:ctrlp_use_caching = 0
