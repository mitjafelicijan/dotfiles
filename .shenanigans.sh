# Software list:
#   git gcc make cmake busybox cifs-utils tree hstr curl 
#   s3cmd xmlstarlet htop nvtop tmux xclip mc ripgrep jq pipx
#   stow rsync entr vim xxd sbcl rlwrap podman podman-compose
#   clang clang-tidy clang-tools-extra clangd clang-analyzer
# Additonal stuff:
#   pipx install pyright
#   go install golang.org/x/tools/gopls@latest

# Only run if the script is being sourced (bashrc).
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
	# Magical environment variables.
	export NIX_SHELL_PRESERVE_PROMPT=1
	export COLORTERM=truecolor
	export TERM=xterm-256color
	export VISUAL=vim
	export EDITOR=vim

	parse_git_branch() {
		git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
	}

	is_inside_nix_shell() {
		nix_shell_name="$(basename "$IN_NIX_SHELL" 2>/dev/null)"
		if [[ -n "$nix_shell_name" ]]; then
			echo " \e[0;36m(nix-shell)\e[0m"
		fi
	}

	# Better prompt.
	export PS1="\n[\033[38;5;166m\]\u@\h\[$(tput sgr0)\]] \033[90m\T\033[0m$(is_inside_nix_shell)\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \w\[$(tput sgr0)\] \n$ "

	# General aliases.
	alias l='ls -lh'
	alias ll='ls -lha'
	alias t='tree -L 2'
	alias ..='cd ..'
	alias grep='grep --color=always'
	alias less='less -R'
	alias tmux='tmux -u'
	alias vi='vim'
	alias server='python3 -m http.server 6969'
	alias gg='lazygit'
	alias newsbarge='newsbarge -feed-file=/home/m/.feeds.txt -out-dir=/home/m/Downloads -days-span=7'

	# Custom folder jump commands.
	alias p='cd ~/Vault/projects'
	alias j='cd ~/Junk/current'
	alias d='cd ~/Downloads'

	# Additional path settings.
	export PATH=$HOME/Applications:$PATH
	export PATH=$HOME/go/bin:$PATH
	export PATH=$HOME/.local/bin:$PATH
	export PATH=/usr/local/go/bin:$PATH

	# Language servers.
	export PATH=$HOME/.local/bin/luals/bin:$PATH

	# Other stuff.
	export PATH=$HOME/Applications/riscv-gnu-toolchain/bin:$PATH
	export PATH=$HOME/Applications/xtensa-lx106-elf/bin:$PATH

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
fi

# Backup to NAS function. Much wow!
backup() {
	CWD=$(pwd)
	VHOME=/home/$USER/Vault
	ME=$(whoami)@$(hostname)

	# Everything dotfiles.
	cd $VHOME && mkdir -p $VHOME/dotfiles && cd $VHOME/dotfiles
	rsync -azhv /home/$USER/.bash_history_infinite bash_history_infinite
	rsync -azhv /home/$USER/.ssh/ ssh
	rsync -azhv /home/$USER/.aws/ aws
	rsync -azhv /home/$USER/.gnupg/ gnupg/

	# WoW settings and addons.
	cd $VHOME
	rsync -azhv /home/$USER/Games/turtlewow/WTF turtlewow
	rsync -azhv /home/$USER/Games/turtlewow/SuperWoWhook.dll turtlewow/
	rsync -azhv /home/$USER/Games/turtlewow/start.sh turtlewow/

	# Sync with NAS.
	rsync -azhvpog \
		--exclude '.venv/' \
		--exclude '.git/' \
		--exclude '.import/' \
		--exclude '.godot/' \
		--exclude '.zig-cache/' \
		--exclude 'node_modules/' \
		--delete \
		$VHOME/ /media/Void/Backup/$ME/

	# Add to log file.
	echo `date +"%D %T"` >> ~/.vault.log
	notify-send "Backup finished successfully."

	# Return back to original directory
	cd $CWD
}

# Toggles between pulseaudio sinks in round-robin.
# Gnome shortcut: ptyxis -- bash -c 'source ~/.shenanigans.sh && togglesink'
togglesink() {
	sinks=($(pactl list short sinks | awk '{print $2}'))
	current_sink=$(pactl get-default-sink)
	current_index=-1

	for i in "${!sinks[@]}"; do
		if [[ "${sinks[$i]}" == "$current_sink" ]]; then
			current_index=$i
			break
		fi
	done

	if [[ $current_index -eq -1 ]]; then
		next_index=0
	else
		next_index=$(( (current_index + 1) % ${#sinks[@]} ))
	fi

	pactl set-default-sink "${sinks[$next_index]}"
	notify-send "Switched to sink: ${sinks[$next_index]}"
}
