set nocompatible
set path+=**
set relativenumber
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
set laststatus=2
set shiftwidth=4
set tabstop=4
set gp=grep\ -irn

filetype plugin on
filetype indent on

syntax enable

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-b> :buffers<cr>:buffer 
nnoremap <C-p> :Explore<cr>

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

" Go autoformat.
function! GoFmt()
	let file = expand('%')
	silent execute "!gofmt -w " . file
	edit!
endfunction
command! GoFmt call GoFmt()
augroup go_autocmd
	autocmd BufWritePost *.go GoFmt
augroup END

