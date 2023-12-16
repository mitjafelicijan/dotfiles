" https://vimhelp.org/options.txt.html

" General sane defaults.
set nocompatible
syntax enable
colorscheme sorbet
nnoremap q: <nop>
set relativenumber
set nohlsearch
set smartcase
set ignorecase
set incsearch
set nowrap
set nobackup
set noswapfile
set autoread
set wildmenu
set autoindent
set encoding=utf8
set backspace=2
set scrolloff=4
set spelllang=en_us

" Buffer navigation remaps.
nnoremap <C-]> :bnext<cr>
nnoremap <C-[> :bprevious<cr>
nnoremap <C-b> :buffers<cr>:buffer 

" Commenting blocks of code.
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,go,scala   let b:comment_leader = '// '
  autocmd FileType sh,ruby,python   let b:comment_leader = '# '
  autocmd FileType conf,fstab       let b:comment_leader = '# '
  autocmd FileType lua              let b:comment_leader = '-- '
  autocmd FileType vim              let b:comment_leader = '" '
augroup END
noremap <silent> gcc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> gcu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Status Line enhancements.
set laststatus=2
set statusline=%f%m%=%y\ %{strlen(&fenc)?&fenc:'none'}\ %l:%c\ %L\ %P
hi StatusLine cterm=NONE ctermbg=black ctermfg=brown
hi StatusLineNC cterm=NONE ctermbg=black ctermfg=darkgray

" Language specific indentation.
filetype plugin indent on
autocmd Filetype make,go,sh setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd Filetype c,cpp,html,javascript,css,python setlocal expandtab tabstop=2 shiftwidth=2

" Throwaway config.
au BufReadPost *.twig set syntax=html

