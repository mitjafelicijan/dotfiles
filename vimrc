set nocompatible
set path+=**
set number relativenumber autoindent
set smartcase ignorecase incsearch
set hidden nowrap nobackup noswapfile autoread
set wildmenu laststatus=2
set encoding=utf8 spelllang=en_us
set backspace=2 scrolloff=4
set shiftwidth=4 tabstop=4
set gp=grep\ -irn

filetype plugin indent on
syntax enable

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-b> :buffers<cr>:buffer 
nnoremap <C-p> :Explore<cr>

" Commenting blocks of code.
" https://stackoverflow.com/a/1676672
augroup commenting_blocks_of_code
	autocmd!
	autocmd FileType c,cpp,go,scala   let b:comment_leader = '// '
	autocmd FileType sh,ruby,python   let b:comment_leader = '# '
	autocmd FileType conf,fstab       let b:comment_leader = '# '
	autocmd FileType lua,sql          let b:comment_leader = '-- '
	autocmd FileType vim              let b:comment_leader = '" '
augroup END
noremap <silent> cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

