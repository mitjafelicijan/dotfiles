# Software list (Void Linux):
#   void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
#   file-roller xfce4-plugins thunar-archive-plugin
#   lm_sensors conky maim xlockmore rofi picom cwm xclip xsetroot st
#   xss-lock wmctrl zip mc htop entr ack cifs-utils rsync xdotool jq
#   clang clang-tools-extra vim git curl tmux hstr tree make cmake
#   ctags stow newsboat mpv rsync python3-pipx lazygit fossil
# Additonal stuff:
#   pipx install pyright
#   go install golang.org/x/tools/gopls@latest

# Only run if the script is being sourced (bashrc).
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
	# Magical environment variables.
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export COLORTERM=truecolor
	export TERM=xterm-256color
	export VISUAL=vim
	export EDITOR=vim

	# Customized Bash prompt.
	SYMBOL='\[\e[38;5;214m\]\$\[\e[0m\]'
	git_branch() { git branch 2>/dev/null | sed -n 's/^\* \(.*\)/(\1)/p'; }
	export PS1="\n$SYMBOL \u@\h \t \w \$(git_branch)\n$SYMBOL "

	# General aliases.
	alias l='ls -lh --group-directories-first'
	alias ll='ls -lha --group-directories-first'
	alias t='tree -L 2'
	alias ..='cd ..'
	alias less='less -R'
	alias tmux='tmux -u'
	alias gg='lazygit'
	alias server='python3 -m http.server 6969'
	alias newsboat='newsboat -r -u ~/.feeds.txt'

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
	PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
	bind '"\e[A": history-search-backward'
	bind '"\e[B": history-search-forward'
	export HSTR_CONFIG=hicolor
	if [[ $- =~ .i. ]]; then bind '"\C-h": "\C-a hstr -- \C-j"'; fi

	# Custom paths.
	export PATH="$PATH:$HOME/.local/bin"
	export PATH="$PATH:$HOME/go/bin"
	export PATH="$PATH:$HOME/Applications"
fi

backup() {
	SNAPSHOT=$(date +%Y-%m-%d)-$(whoami)@$(hostname)
	mkdir -p /tmp/$SNAPSHOT

	archive_sets=(
		"ssh.zip $HOME/.ssh"
		"bash_history_infinite.zip $HOME/.bash_history_infinite"
		"projects.zip $HOME/Projects"
		"twow.zip $HOME/Games/turtlewow/WTF $HOME/Games/turtlewow/SuperWoWhook.dll $HOME/Games/turtlewow/dlls.txt $HOME/Games/turtlewow/wow.sh"
	)

	for entry in "${archive_sets[@]}"; do
		zip -r /tmp/$SNAPSHOT/${entry} -x "**/.venv/*" "**/.git/*" "**/.import/*" "**/.godot/*" "**/.zig-cache/*" "**/node_modules/*"
	done

	rsync -azhv /tmp/$SNAPSHOT /media/Void/Backup
	rm -Rf /tmp/$SNAPSHOT
}

pushcode() {
	find ~/Projects/ -type f -name "*.fossil" | while read -r file; do
		s3cmd put "$file" s3://vault/code/
		s3cmd setacl s3://vault/code/$(basename $file) --acl-public
	done
}

screenrecord() {
	ffmpeg -f x11grab -s 3840x2560 -i :0.0 -r 60 -vcodec h264_nvenc -preset fast ~/Videos/$(date +%Y-%m-%d-%H-%M-%S).mp4
}
