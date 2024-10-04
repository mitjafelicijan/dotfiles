call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/gv.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'jiangmiao/auto-pairs'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'yegappan/grep'
  Plug 'dense-analysis/ale'
call plug#end()

colorscheme sorbet
hi Normal guibg=NONE ctermbg=NONE
hi StatusLine ctermfg=245 ctermbg=235 cterm=none
hi StatusLineNC ctermfg=245 ctermbg=none cterm=none

set number relativenumber autoindent signcolumn=yes
set hidden nowrap nobackup noswapfile autoread updatetime=300
set encoding=utf8 spelllang=en_us
set backspace=2 scrolloff=4
set shiftwidth=4 tabstop=4

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-q> :copen<cr>
nnoremap <C-p> :CtrlP<cr>
nnoremap <C-b> :CtrlPBuffer<cr>
nnoremap <C-g> :Rg<cr>
nnoremap <C-k> :ALEHover<cr>
nnoremap <C-j> :ALEDetail<cr>

nmap <silent> gr :ALEFindReferences<cr>
nmap <silent> gd :ALEGoToDefinition<cr>
nmap <silent> re :ALERename<cr>

let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_floating_window_border = 0
let g:ale_virtualtext_cursor = 0
let g:ale_set_quickfix = 1

