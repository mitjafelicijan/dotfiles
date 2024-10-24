#!/usr/bin/env sh

set -x

mkdir -p ~/.config/i3
mkdir -p ~/.config/i3status/
mkdir -p ~/.newsboat

ln -s ~/.dotfiles/shenanigans.sh ~/.shenanigans.sh
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/i3config ~/.config/i3/config
ln -s ~/.dotfiles/i3status  ~/.config/i3status/config
ln -s ~/.dotfiles/rssfeeds  ~/.newsboat/urls

