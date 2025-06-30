# Software list (Void Linux):
#   void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
#   file-roller xfce4-screenshooter xfce4-plugins xsetroot thunar-archive-plugin
#   clang clang-tools-extra vim stow git curl tmux hstr tree make cmake
#   entr ack lazygit newsboat htop mc

# Only run if the script is being sourced (bashrc).
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
	# Magical environment variables.
	export COLORTERM=truecolor
	export TERM=xterm-256color
	export VISUAL=vim
	export EDITOR=vim

	git_branch() {
		git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
	}

	# Better prompt.
	export PS1='\n# \u@\h \T \w $(git_branch)\n# '

	# General aliases.
	alias l='ls -lh'
	alias ll='ls -lha'
	alias t='tree -L 2'
	alias ..='cd ..'
	alias grep='grep -irn --color=always'
	alias less='less -R'
	alias tmux='tmux -u'
	alias server='python3 -m http.server 6969'
	alias newsboat='newsboat -r -u ~/.feeds.txt'
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
fi

wow() {
	cd ~/Games/turtlewow && ./wow.sh
}
