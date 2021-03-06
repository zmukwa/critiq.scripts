#!/bin/bash

set -e

SCR_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ "$1" == "--help" ]; then
    echo "Usage: ./install.sh [--help | --full [--no-x]]"
    echo "           Without options, install vim configuration files alone."
    echo "  --full   Full installation"
    echo "  --no-x   Skip X-related configurations"
    echo "           ... including fonts, firefox config, etc."
    echo "  --help   Display this message"
    exit
fi

function _symlink {
    if [ "$#" == 1 ]; then
        src="$SCR_DIR/$1"
        link="$HOME/.$1"
    elif [ "$#" == 2 ]; then
        src="$1"
        link="$2"
    else
        echo "Bad call to _symlink"
        echo "Expected 1 or 2 arguments, got $#"
        echo "Exiting..."
        exit
    fi
    [ -e "$link" ] && echo "Path exists; ignoring $link" || \
        (ln -s "$src" "$link" && echo "Linked $link")
}

mkdir -p $HOME/.config/nvim
echo "Directory ~/.config/nvim"

mkdir -p $HOME/.cache/nvim/{swps,undos,logs}
echo "Directory ~/.cache/nvim/{swps,undos,logs}"

_symlink config/nvim/base
_symlink config/nvim/colors
_symlink config/nvim/autoload
_symlink config/nvim/init.vim
_symlink "$SCR_DIR/config/nvim/fallback.vim" $HOME/.vimrc
_symlink $HOME/.config/nvim $HOME/.vim

vim -u $SCR_DIR/config/nvim/minimal.vim # download vim-plug + plugins
if [ "$1" != "--full" ]; then
    echo $'\n# Skipping zsh, git, tmux, python, and X-related configs!'
    exit
fi

mkdir -p $HOME/.cache/zsh
echo "Directory ~/.cache/zsh"

mkdir -p $HOME/.local/bin
echo "Directory ~/.local/bin"

_symlink zshrc
_symlink zsh
_symlink gitconfig
_symlink tmux.conf
_symlink local/bin/tmux-preswitch.sh

_symlink config/pystartup

if [ "$2" == "--no-x" ]; then
    echo $'\n# Skipping X-related configs!'
    exit
fi

# ~/.Xresources
if ! [ -e $HOME/.Xresources ]; then
    sed "s:\${HOME}:$HOME:" "$SCR_DIR/Xresources" > $HOME/.Xresources
    echo "Created ~/.Xresources"
else
    echo "Path exists; ignoring ~/.Xresources"
fi
_symlink config/Xresources.d
_symlink config/Xmodmap

# Fonts (requires package libotf)
mkdir -p ~/.local/share/fonts
echo "Directory ~/.local/share/fonts"
curl -fLo ~/.local/share/fonts/MonacoB.otf \
  https://raw.githubusercontent.com/vjpr/monaco-bold/master/MonacoB/MonacoB.otf
curl -fLo ~/.local/share/fonts/MonacoB-Bold.otf \
  https://raw.githubusercontent.com/vjpr/monaco-bold/master/MonacoB/MonacoB-Bold.otf
curl -fLo ~/.local/share/fonts/FontAwesome.otf \
  https://raw.githubusercontent.com/FortAwesome/Font-Awesome/master/fonts/FontAwesome.otf
fc-cache -vf
echo

mkdir -p $HOME/.local/share/applications
mkdir -p $HOME/.local/share/icons/hicolor/scalable/apps
echo "Directories ~/.local/share/... for nvim.desktop and nvim.svg"

_symlink local/share/applications/nvim.desktop
_symlink local/share/icons/hicolor/scalable/apps/nvim.svg

ffpath=`echo $HOME/.mozilla/firefox/*.default`
mkdir -p $ffpath/chrome
echo "Directory $ffpath/chrome"
_symlink "$SCR_DIR/mozilla/firefox/_.default/chrome/userChrome.css" \
    $ffpath/chrome/userChrome.css

_symlink config/i3

echo $'\n# Completed!'
