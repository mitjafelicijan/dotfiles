set nocompatible exrc secure
filetype plugin on

call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'mitjafelicijan/sniper.vim'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'dense-analysis/ale'
	Plug 'airblade/vim-gitgutter'
call plug#end()

set encoding=utf8 spelllang=en_us laststatus=2 tabstop=4 shiftwidth=4
set number autoindent cursorline ignorecase hlsearch incsearch signcolumn=yes
set hidden nowrap nobackup noswapfile noundofile autoread updatetime=300
set backspace=indent,eol,start completeopt=menuone path+=**
set foldmethod=syntax foldlevel=99 foldopen= lazyredraw scrolloff=10
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/vendor,tags,*.o,*.a,*.so
set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
colorscheme wildcharm

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

nnoremap <C-Right> :bnext<CR>
nnoremap <C-Left> :bprevious<CR>
nnoremap <C-q> :copen<CR>
nnoremap <C-b> :CtrlPBuffer<CR>
nnoremap <C-k> :ALEHover<CR>
nnoremap <C-j> :ALEDetail<CR>
nnoremap <M-Right> :cnext<CR>
nnoremap <M-Left> :cprevious<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <leader>t :term<CR>
nnoremap <Leader>q :nohlsearch<CR>
nnoremap <Leader>e :ALEPopulateQuickfix<CR>:sleep 100m<CR>:copen<CR>
nnoremap <leader>w :silent! grep! <cword> \| cwindow \| redraw!<CR>

nmap <silent> gr :ALEFindReferences -quickfix<CR>:sleep 100m<CR>:copen<CR>
nmap <silent> gd :ALEGoToDefinition<CR>
nmap <silent> re :ALERename<CR>

let g:ctrlp_use_caching = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ale_hover_to_floating_preview = 1
let g:ale_detail_to_floating_preview = 1
let g:ale_floating_window_border = 0
let g:ale_virtualtext_cursor = 0
let g:ale_set_quickf = 1
