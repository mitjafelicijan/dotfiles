# Software list.
# cifs-utils tree s3cmd xclip mc gnupg ripgrep
# jq xmlstarlet tilix fzf hx

# Magical environment variables.

NIX_SHELL_PRESERVE_PROMPT=1
TERM=xterm-256color
EDITOR=hx

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

export PS1="[\033[38;5;9m\]\u@\h\[$(tput sgr0)\]]$(is_inside_nix_shell)\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \w\[$(tput sgr0)\] \n$ "

# General aliases.

alias c='clear'
alias l='ls -lh'
alias ll='ls -lha'
alias t='tree -L 2'
alias ..='cd ..'
alias h='history'
alias x='exit'
alias grep='grep --color=always'
alias less='less -R'
alias gg='lazygit'
alias server='python3 -m http.server 6969'

# Custom folder jump commands.

alias p='cd ~/Vault/projects'
alias j='cd ~/Junk/current'
alias d='cd ~/Downloads'
alias v='cd ~/Vault'

# Additional path settings.

export PATH=$HOME/Vault/bin:$PATH
export PATH=$HOME/Applications:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/Android/Sdk/platform-tools:$PATH
export PATH=$HOME/Android/Sdk/tools:$PATH

# History and search.

HISTCONTROL=ignoreboth
shopt -s histappend
export HISTSIZE=
export HISTFILESIZE=
export HISTFILE=~/.bash_history_infinite
PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
alias hh=hstr
export HSTR_CONFIG=hicolor
if [[ $- =~ .i. ]]; then bind '"\C-h": "\C-a hstr -- \C-j"'; fi

# Useful function. Much wow!

turtle() {
	cd ~/Games/Turtle
	./start.sh
}

backup() {
	VHOME=/home/$USER/Vault
	ME=$(whoami)@$(hostname)

	mkdir -p $VHOME/dotfiles
	cd $VHOME/dotfiles

	# Make a copy of dotfiles.
	cp /home/$USER/.shenanigans.sh shenanigans.sh
	cp /home/$USER/.bash_history_infinite bash_history_infinite
	cp /home/$USER/.smbcredentials smbcredentials
	cp /home/$USER/.gitconfig gitconfig
	cp /home/$USER/.s3cfg s3cfg

	cp /home/$USER/.vimrc vimrc
	cp /home/$USER/.config/emacs/init.el init.el
	cp /home/$USER/.config/helix/config.toml config.toml
	cp /home/$USER/.newsbeuter/urls urls

	cp -Rf /home/$USER/.ssh/ ./
	cp -Rf /home/$USER/.aws/ ./

	dconf dump /com/gexperts/Tilix/ > tilix.dconf
	# dconf load /com/gexperts/Tilix/ < tilix.dconf

	# Backup screenshots.
	mkdir -p $VHOME/pictures
	cp -rfn ~/Pictures/* $VHOME/pictures/

	# Backup screencasts.
	mkdir -p $VHOME/videos
	cp -rfn ~/Videos/* $VHOME/videos/

	# Backup Turtle WoW stuff.
	mkdir -p $VHOME/turtle-wow
	cp -rfn ~/Games/Turtle/Interface $VHOME/turtle-wow/
	cp -rfn ~/Games/Turtle/WTF $VHOME/turtle-wow/
	cp -rfn ~/Games/Turtle/start.sh $VHOME/turtle-wow/
	
	# Sync with NAS.
	rsync -azv \
		--exclude '.venv/' \
		--exclude '.git/' \
		--exclude '.import/' \
		--exclude '.godot/' \
		--exclude 'node_modules/' \
		--delete \
		$VHOME/ /media/Void/Backup/$ME/

	# Sync to off-site DO S3 bucket.
	s3cmd sync \
		--host-bucket=vault \
		--delete-removed \
		--exclude 'node_modules/*' \
		--exclude '.git/*' \
		--exclude '.import/*' \
		--exclude '.godot/*' \
		--exclude '.venv/*' \
		$VHOME/ s3://vault/backup/$ME/

	# Add to log file.
	echo `date +"%D %T"` >> ~/.vault.log
}
