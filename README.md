![Unga Bunga](https://github.com/mitjafelicijan/dotfiles/assets/296714/2ea7852a-8297-40c4-a9b1-0f6cba6c701f)

Clone the repo first...

```sh
git clone git@github.com:mitjafelicijan/dotfiles.git ~/.dotfiles
```

Then create symbolic links to actual config files.

```sh
ln -s ~/.dotfiles/alacritty.yml ~/.alacritty.yml
ln -s ~/.dotfiles/shenanigans.sh ~/.shenanigans.sh
ln -s ~/.dotfiles/helix.toml ~/.config/helix/config.toml
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/newsboat ~/.newsboat/config
ln -s ~/.dotfiles/urls ~/.newsboat/urls
ln -s ~/.dotfiles/gf2_config.ini ~/.config/gf2_config.ini
```

