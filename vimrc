let mapleader = "\<Space>"

call plug#begin()
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'jiangmiao/auto-pairs'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': 'npm install'}
call plug#end()

colorscheme sorbet
hi Normal guibg=NONE ctermbg=NONE
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

nmap <silent>[g <Plug>(coc-diagnostic-prev)
nmap <silent>]g <Plug>(coc-diagnostic-next)
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
nmap <leader>cf <Plug>(coc-fix-current)

