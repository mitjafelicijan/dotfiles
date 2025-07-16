# Software list (Void Linux):
#   void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
#   file-roller xfce4-screenshooter xfce4-plugins xsetroot thunar-archive-plugin
#   clang clang-tools-extra vim stow git curl tmux hstr tree make cmake xclipi jq
#   entr ack lazygit newsboat htop mc mpv cifs-utils zip rsync python3-pipx jq
#   lm_sensors conky
# Additonal stuff:
#   pipx install pyright
#   go install golang.org/x/tools/gopls@latest

# Only run if the script is being sourced (bashrc).
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
	# Magical environment variables.
	export COLORTERM=truecolor
	export TERM=xterm-256color
	export VISUAL=vim
	export EDITOR=vim

	# Customized Bash prompt.
	SYMBOL='\[\e[38;5;214m\]\$\[\e[0m\]'
	git_branch() { git branch 2>/dev/null | sed -n 's/^\* \(.*\)/(\1)/p'; }
	export PS1="\n$SYMBOL \u@\h \t \w \$(git_branch)\n$SYMBOL "

	# General aliases.
	alias l='ls -lh'
	alias ll='ls -lha'
	alias t='tree -L 2'
	alias ..='cd ..'
	alias less='less -R'
	alias tmux='tmux -u'
	alias server='python3 -m http.server 6969'
	alias newsboat='newsboat -r -u ~/.feeds.txt'
	alias wow='sh ~/Games/turtlewow/wow.sh &'
	alias ack='ack -S'
	alias gg='lazygit'

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
