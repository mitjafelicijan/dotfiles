# Software list:
#   xss-lock xkbset xclip xsel xwininfo cifs-utils picom ffmpeg
#   vim git tmux maim mc htop entr rsync jq rofi stow newsboat 
#   st rsync curl hstr tree make gdb nvtop ctags mpv lazygit fd

# Only run if the script is being sourced (bashrc).
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
	# Magical environment variables.
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export COLORTERM=truecolor
	export TERM=xterm-256color
	export VISUAL=nvim
	export EDITOR=nvim

	# Customized Bash prompt.
	SYMBOL='\[\e[38;5;214m\]\$\[\e[0m\]'
	git_branch() { git branch 2>/dev/null | sed -n 's/^\* \(.*\)/(\1)/p'; }
	export PS1="\n$SYMBOL \u@\h \t \w \$(git_branch)\n$SYMBOL "

	# General aliases.
	alias l='ls -lh --group-directories-first --color=always'
	alias ll='ls -lha --group-directories-first --color=always'
	alias t='tree -L 2'
	alias ..='cd ..'
	alias gg='lazygit'
	alias less='less -R'
	alias tmux='tmux -T 256 -u'
	alias vim='nvim'
	alias server='python3 -m http.server 6969'
	alias newsboat='newsboat -r -u ~/.feeds.txt'
	alias emptytrash='gio trash --empty'

	# Custom folder jump commands.
	alias j='cd ~/Junk'
	alias p='cd ~/Projects'
	alias d='cd ~/Downloads'

	# History and search. Stolen from J.
	HISTCONTROL=ignoreboth
	shopt -s histappend
	export HISTSIZE=
	export HISTFILESIZE=
	export HISTFILE=~/.bash_history_infinite
	PROMPT_COMMAND="history -a; ${PROMPT_COMMAND}"
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
	export HSTR_CONFIG=hicolor
	if [[ $- =~ .i. ]]; then bind '"\C-h": "\C-a hstr -- \C-j"'; fi

	# Custom paths.
	export PATH="$PATH:$HOME/.local/bin"
	export PATH="$PATH:$HOME/.cargo/bin"
	export PATH="$PATH:$HOME/go/bin"
	export PATH="$PATH:$HOME/Applications"
	export PATH="$PATH:$HOME/.local/bin/zig"
	export PATH="$PATH:$HOME/.local/bin/c3"
	export PATH="$PATH:$HOME/.local/bin/odin"
fi

backup() {
	SNAPSHOT=$(date +%Y-%m-%d)-$(whoami)@$(hostname)
	mkdir -p /tmp/$SNAPSHOT

	archive_sets=(
		"ssh.zip $HOME/.ssh"
		"bash_history_infinite.zip $HOME/.bash_history_infinite"
		"projects.zip $HOME/Projects"
	)

	for entry in "${archive_sets[@]}"; do
		zip -r /tmp/$SNAPSHOT/${entry} -x "**/.venv/*" "**/.git/*" "**/.import/*" "**/.godot/*" "**/.zig-cache/*" "**/node_modules/*"
	done

	rsync -azhv /tmp/$SNAPSHOT /media/Void/Backup
	rm -Rf /tmp/$SNAPSHOT
}

slugify() {
	local text="$1"
	echo "$text" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

worldclocks() {
	printf "%-18s %s\n" "Local:" "$(TZ='Europe/Ljubljana' date +'%a %H:%M')"
	printf "%-18s %s\n" "Brisbane:" "$(TZ='Australia/Brisbane' date +'%a %H:%M')"
	printf "%-18s %s\n" "San Francisco:" "$(TZ='America/Los_Angeles' date +'%a %H:%M')"
	printf "%-18s %s\n" "New York:" "$(TZ='America/New_York' date +'%a %H:%M')"
}

record() {
	mkdir -p "$HOME/Videos"
	win=$(xwininfo -int | awk '/Window id:/{print $4; exit}')
	[ -z "$win" ] && { echo "no window picked"; exit 1; }

	eval $(
		xwininfo -id "$win" | awk '
			/Absolute upper-left X:/{x=$4}
			/Absolute upper-left Y:/{y=$4}
			/Width:/{w=$2}
			/Height:/{h=$2}
		END{printf("X=%s;Y=%s;W=%s;H=%s\n", x, y, w, h)}
		'
	)

	if [ -z "$W" ] || [ -z "$H" ]; then
		echo "failed to get geometry"; exit 1
	fi

	W=$((W / 2 * 2))
	H=$((H / 2 * 2))

	ts=$(date '+%F-%H-%M-%S')
	out="$HOME/Videos/record-${ts}.mp4"
	echo "Recording ${W}x${H}+${X},${Y} -> ${out}"

	ffmpeg -y -f x11grab -video_size "${W}x${H}" -framerate 60 -i "${DISPLAY:-:0.0}+${X},${Y}" -c:v libx264 -preset veryfast -crf 23 -pix_fmt yuv420p "$out"
}
