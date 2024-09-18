set nocompatible
set number relativenumber autoindent
set ignorecase smartcase incsearch
set hidden nowrap nobackup noswapfile autoread
set wildmenu wildmode=list:longest,full laststatus=2
set encoding=utf8 spelllang=en_us
set backspace=2 scrolloff=4
set shiftwidth=4 tabstop=4
set path+=** gp=grep\ -irn

filetype plugin indent on
syntax enable

" Disable auto-formatting for Zig files.
let g:zig_fmt_autosave = 0

nnoremap <C-Right> :bnext<cr>
nnoremap <C-Left> :bprevious<cr>
nnoremap <C-b> :buffers<cr>:buffer
nnoremap <C-q> :copen<cr>

" Personal tabs/spaces settings.
autocmd Filetype make,go,sh setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd Filetype c,cpp,zig setlocal expandtab tabstop=4 shiftwidth=4
autocmd Filetype lua,nix,html,xml,javascript,css setlocal expandtab tabstop=2 shiftwidth=2

" External auto-formatters.
autocmd FileType c,cpp setlocal formatprg=clang-format
autocmd FileType go setlocal formatprg=gofmt

" Code commenting - https://stackoverflow.com/a/1676672.
augroup CodeCommenting
	autocmd!
	autocmd FileType c,cpp,go,zig,javascript  let b:comment_leader = '// '
	autocmd FileType sh,ruby,python   let b:comment_leader = '# '
	autocmd FileType conf,fstab       let b:comment_leader = '# '
	autocmd FileType lua,sql          let b:comment_leader = '-- '
	autocmd FileType vim              let b:comment_leader = '" '
augroup END
noremap <silent> cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> cu :<C-B>silent <C-E>s/^\(\s*\)\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" FZF - fuzzy finder integration.
function! FZF()
	let t=tempname()
	silent execute '!fzf --preview=''cat {}'' --multi|awk ''{print $1":1:0"}'' > '.fnameescape(t)
	execute 'cfile '.t|redraw!
	call delete(t)
endfunction
nnoremap <C-p> :call FZF()<cr>

