# Magical environment variables.
NIX_SHELL_PRESERVE_PROMPT=1
TERM=xterm-256color
VISUAL=vim
EDITOR=vim

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
export PS1="[\033[38;5;166m\]\u@\h\[$(tput sgr0)\]]$(is_inside_nix_shell)\[\033[33m\]\$(parse_git_branch)\[\033[00m\] \w\[$(tput sgr0)\] \n$ "

# General aliases.
alias ls='ls --color=none'
alias l='ls -lh --color=none'
alias ll='ls -lha --color=none'
alias t='tree -L 2'
alias ..='cd ..'
alias grep='grep --color=always'
alias less='less -R'
alias tmux='tmux -u'
alias vi='vim'
alias server='python3 -m http.server 6969'

# Custom folder jump commands.
alias p='cd ~/Vault/projects'
alias j='cd ~/Junk/current'
alias d='cd ~/Downloads'

# Additional path settings.
export PATH=$HOME/Applications:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=/usr/local/go/bin:$PATH

# Language server.
export PATH=$HOME/.local/bin/luals/bin:$PATH

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

# Machine provision script for essential software.
# This is meant to be used on Debian 11+.
provision() {
	doas apt install \
		build-essential git gcc make busybox cifs-utils tree hstr s3cmd \
		xmlstarlet htop nvtop tmux picom scrot xclip mc ripgrep jq \
		rsync doas newsboat entr clang clang-tidy clang-tools \
		libx11-dev libxinerama-dev libxft-dev x11-xserver-utils \
		stow podman podman-compose 
}

# Backup to NAS function. Much wow!
backup() {
	CWD=$(pwd)
	VHOME=/home/$USER/Vault
	ME=$(whoami)@$(hostname)

	mkdir -p $VHOME/dotfiles
	cd $VHOME/dotfiles

	# Make a copy of certain files.
	rsync -azhv /home/$USER/.bash_history_infinite bash_history_infinite
	rsync -azhv /home/$USER/.ssh/ ssh
	rsync -azhv /home/$USER/.aws/ aws
	rsync -azhv /home/$USER/.gnupg/ gnupg/

	# Sync with NAS.
	rsync -azhvpog \
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
	notify-send "Backup finished successfully."

	# Return back to original directory
	cd $CWD
}

# Simple ticket system based on https://github.com/mitjafelicijan/ticket.
export TICKETS=~/Vault/tickets
tt() {
	if [ "$(uname -s)" != "Linux" ]; then
		printf "Currently only Linux is supported.\n"
		return 1
	fi

	if [ -z "$TICKETS" ]; then
		TICKETS="$HOME/tickets"
	fi

	mkdir -p $TICKETS

	# Display open tickets if no argument provided.
	if [ -z "$1" ]; then
		echo "`tt -o`"
		return 0
	fi

	case $1 in
		-n|-new)
			# ticket_id=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 10 | head -n 1)
			ticket_id=$(echo -n "$(date)" | md5sum | cut -c 9-20)
			ticket_file=$TICKETS/$ticket_id
			printf "id: %s\n" $ticket_id > $ticket_file
			printf "responsible: %s\n" `whoami`@`hostname` >> $ticket_file
			printf "created: %s\n" "`date`" >> $ticket_file
			printf "status: open\n" >> $ticket_file
			printf "title: ?\n" >> $ticket_file
			printf "====\n" >> $ticket_file
			printf "Description...\n" >> $ticket_file
			$EDITOR $ticket_file
			;;
		-o|-open)
			printf "%-14s %-21s %s\n" "Ticket ID" "Created at" "Title"
			printf "%0.s-" {1..100}
			printf "\n"
			grep --color=never -l 'status: open' $TICKETS/* | while read file; do
				id=$(head -n 1 "$file" | tail -n 1 | awk '{ print $2 }')
				title=$(head -n 5 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate=$(head -n 3 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate_fmt=$(date -d "$cdate" "+%Y-%m-%d %H:%M:%S")
				printf "%-14s %-20s %.66s\n" "$id" "$cdate_fmt" "$title"
			done
			;;
		-c|-closed)
			printf "%-14s %-21s %s\n" "Ticket ID" "Created at" "Title"
			printf "%0.s-" {1..100}
			printf "\n"
			grep --color=never -l 'status: closed' $TICKETS/* | while read file; do
				id=$(head -n 1 "$file" | tail -n 1 | awk '{ print $2 }')
				title=$(head -n 5 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate=$(head -n 3 "$file" | tail -n 1 | awk '{$1=""; print $0}')
				cdate_fmt=$(date -d "$cdate" "+%Y-%m-%d %H:%M:%S")
				printf "%-14s %-20s %.66s\n" "$id" "$cdate_fmt" "$title"
			done
			;;
		-h|-help)
			printf "Usage: ticket [option]\n"
			printf "  -n, -new          creates a new ticket\n"
			printf "  -o, -open         lists open tickets\n"
			printf "  -c, -closed       lists closed tickets\n"
			printf "  -h, -help         shows this help\n"
			;;
		*)
			if [ -e "$TICKETS/$1" ] && [ -f "$TICKETS/$1" ]; then
				$EDITOR "$TICKETS/$1"
			else
				printf "Ticket not found: $TICKETS/$1\n"
			fi
			;;
	esac
}

# Toggles between pulseaudio sinks in round-robin.
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

