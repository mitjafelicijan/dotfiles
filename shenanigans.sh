# Software list.
# cifs-utils treei tig hstr s3cmd xclip mc gnupg ripgrep jq xmlstarlet fzf htop nvtop newsboat tmux ctags

# Magical environment variables.

NIX_SHELL_PRESERVE_PROMPT=1
TERM=xterm-256color
VISUAL=vim
EDITOR=vim

# Better prompt.

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

is_inside_nix_shell() {
	nix_shell_name="$(basename "$IN_NIX_SHELL" 2>/dev/null)"
	if [[ -n "$nix_shell_name" ]]; then
		echo " \e[0;36m(nix-shell)\e[0m"
	fi
}

export PS1="[\033[38;5;166m\]\u@\h\[$(tput sgr0)\]]$(is_inside_nix_shell)\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \w\[$(tput sgr0)\] \n$ "

# General aliases.

alias ls='ls --color=none'
alias l='ls -lh --color=none'
alias ll='ls -lha --color=none'
alias t='tree -L 2'
alias ..='cd ..'
alias h='history'
alias grep='grep --color=always'
alias less='less -R'
alias tmux='tmux -u'
alias vi='vim'
alias server='python3 -m http.server 6969'
alias www='lynx -accept_all_cookies -scrollbar https://lite.duckduckgo.com'
alias st='st -g 90x40 -f "BerkeleyMono:style=Bold:size=16:antialias=true:autohint:true"'

# Custom folder jump commands.

alias p='cd ~/Vault/projects'
alias n='cd ~/Vault/notes'
alias j='cd ~/Junk/current'
alias d='cd ~/Downloads'

# Additional path settings.

export PATH=$HOME/Applications:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=/usr/local/go/bin:$PATH

# Zig paths.
export PATH=$HOME/.local/bin/zls-x86_64-linux-0.13.0:$PATH
export PATH=$HOME/.local/bin/zig-linux-x86_64-0.14.0-dev.1587+feaee2ba1:$PATH

# FZF settings.

export FZF_DEFAULT_COMMAND='rg --files --hidden'

# History and search. Stolen from J.

HISTCONTROL=ignoreboth
shopt -s histappend
export HISTSIZE=
export HISTFILESIZE=
export HISTFILE=~/.bash_history_infinite
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export HSTR_CONFIG=hicolor
if [[ $- =~ .i. ]]; then bind '"\C-h": "\C-a hstr -- \C-j"'; fi

# Useful function. Much wow!

wow() {
	cd ~/Games/turtlewow/
	./start.sh
}

backup() {
	CWD=$(pwd)
	VHOME=/home/$USER/Vault
	ME=$(whoami)@$(hostname)

	mkdir -p $VHOME/dotfiles
	cd $VHOME/dotfiles

	# Make a copy of dotfiles.
	cp /home/$USER/.shenanigans.sh shenanigans.sh
	cp /home/$USER/.bash_history_infinite bash_history_infinite
	cp /home/$USER/.smbcredentials smbcredentials
	cp /home/$USER/.gitconfig gitconfig
	cp /home/$USER/.vimrc vimrc
	cp /home/$USER/.tmux.conf tmux.conf
	cp /home/$USER/.config/helix/config.toml config.toml
	cp /home/$USER/.newsboat/urls urls
	cp /home/$USER/.newsboat/cache.db cache.db

	cp -Rf /home/$USER/.ssh/ ./
	cp -Rf /home/$USER/.aws/ ./

	find /home/$USER/Videos -type f -name "*.webm" -exec cp -n {} $VHOME/videos/ \;
	find /home/$USER/Pictures -type f -name "*.png" -exec cp -n {} $VHOME/pictures/ \;

	cp -Rf /home/$USER/Notebooks ./

	mkdir ../twow
	cp -Rf /home/$USER/Games/turtlewow/Interface ../twow
	cp -Rf /home/$USER/Games/turtlewow/WTF ../twow
	cp -Rf /home/$USER/Games/turtlewow/start.sh ../twow/
	cp -Rf /home/$USER/Games/turtlewow/icon.png ../twow/
	cp -Rf /home/$USER/Games/turtlewow/start.sh ../twow/

	# Sync with NAS.
	rsync -azv \
		--exclude '.venv/' \
		--exclude '.git/' \
		--exclude '.import/' \
		--exclude '.godot/' \
		--exclude '.zig-cache/' \
		--exclude 'node_modules/' \
		--exclude 'digg-v5/' \
		--delete \
		$VHOME/ /media/Void/Backup/$ME/

	# Add to log file.
	echo `date +"%D %T"` >> ~/.vault.log

	# Return back to original directory
	cd $CWD
}

