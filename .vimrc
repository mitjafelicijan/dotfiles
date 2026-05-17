set nocompatible exrc secure
filetype plugin on

call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'dense-analysis/ale'
	Plug 'airblade/vim-gitgutter'
	Plug 'mitjafelicijan/sniper.vim'
	Plug 'mitjafelicijan/c3.vim'
	Plug 'mitjafelicijan/llm.vim'
call plug#end()

set encoding=utf8 spelllang=en_us laststatus=2 tabstop=4 shiftwidth=4
set number autoindent cursorline ignorecase hlsearch incsearch signcolumn=yes
set hidden nowrap nobackup noswapfile noundofile autoread updatetime=300
set backspace=indent,eol,start completeopt=menuone path+=**
set foldmethod=syntax foldlevel=99 foldopen= lazyredraw scrolloff=10
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/vendor,tags,*.o,*.a,*.so
set completeopt=menu,menuone,popup,noselect,noinsert
set background=dark
colorscheme wildcharm

if executable('rg')
	set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
	set grepformat=%f:%l:%c:%m
endif

nnoremap <C-Right>  :bnext<CR>
nnoremap <C-Left>   :bprevious<CR>
nnoremap <M-Right>  :cnext<CR>
nnoremap <M-Left>   :cprevious<CR>
nnoremap <C-q>      :copen<CR>
nnoremap <C-b>      :CtrlPBuffer<CR>
nnoremap <C-k>      :ALEHover<CR>
nnoremap <C-j>      :ALEDetail<CR>
nnoremap <Leader>d  :bd!<CR>
nnoremap <Leader>q  :nohlsearch<CR>
nnoremap <Leader>e  :ALEPopulateQuickfix<CR>:sleep 100m<CR>:copen<CR>
nnoremap <leader>w  :silent! grep! <cword> \| cwindow \| redraw!<CR>
nnoremap <A-Down>   :m .+1<CR>==
nnoremap <A-Up>     :m .-2<CR>==
nnoremap <A-Right>  >>
nnoremap <A-Left>   <<
vnoremap <A-Down>   :m '>+1<CR>gv=gv
vnoremap <A-Up>     :m '<-2<CR>gv=gv
vnoremap <A-Right>  >gv
vnoremap <A-Left>   <gv
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
let g:ale_set_quickf = 1
