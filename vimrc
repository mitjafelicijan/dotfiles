set nocompatible
set number relativenumber autoindent
set ignorecase smartcase incsearch
set hidden nowrap nobackup noswapfile autoread
set wildmenu wildmode=longest,list,full laststatus=2
set encoding=utf8 spelllang=en_us
set backspace=2 scrolloff=4
set shiftwidth=4 tabstop=4
set path+=** gp=grep\ -irn

filetype plugin indent on
syntax enable

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-b> :buffers<cr>:buffer
nnoremap <C-q> :copen<cr>

" Personal tabs/spaces settings.
autocmd Filetype make,go,sh setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd Filetype c,cpp,lua setlocal expandtab tabstop=4 shiftwidth=4
autocmd Filetype nix,html,javascript,css setlocal expandtab tabstop=2 shiftwidth=2

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
noremap <silent> cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Function to auto format source code files.
function! Format()
	if &filetype == 'c' | write | call system('clang-format -i '.expand('%')) | edit! | endif
	if &filetype == 'go' | write | call system('go fmt '.expand('%')) | edit! | endif
endfunction
command! Format call Format()

" FZF integration.
function! FZF()
	let t=tempname()
	silent execute '!fzf --preview=''cat {}'' --multi|awk ''{print $1":1:0"}'' > '.fnameescape(t)
	execute 'cfile '.t|redraw!
	call delete(t)
endfunction
nnoremap <C-p> :call FZF()<cr>

