#!/bin/bash

if [ "$1" == "--help" ]; then
    echo "Usage: ./uninstall.sh [--help | --full]"
    echo "           Without options, uninstall vim configuration files alone."
    echo "  --full   Full uninstallation"
    echo "  --help   Display this message"
    exit
fi

function _unlink {
    if [ "$#" != 1 ]; then
        echo "Bad call to _unlink"
        echo "Expected exactly 1 arguments, got $#"
        echo "Exiting..."
        exit
    fi
    [ ! -e "$1" ] && echo "Does not exist; ignoring $1" && return 0
    [ ! -L "$1" ] && echo "Not a symlink; ignoring $1" && return 0
    rm "$1" && echo "Removed symlink $1"
}

_unlink $HOME/.config/nvim/base
_unlink $HOME/.config/nvim/colors
_unlink $HOME/.config/nvim/autoload
_unlink $HOME/.config/nvim/init.vim
_unlink $HOME/.vimrc
_unlink $HOME/.vim

if [ "$1" != "--full" ]; then
    echo $'\n# Skipping zsh, git, tmux, python, and X-related configs!'
    exit
fi

_unlink $HOME/.zshrc
_unlink $HOME/.zsh
_unlink $HOME/.gitconfig
_unlink $HOME/.tmux.conf
_unlink $HOME/.local/bin/tmux-preswitch.sh

_unlink $HOME/.config/pystartup

_unlink $HOME/.config/Xresources.d
if [ -e $HOME/.Xresources ]; then
    printf "Remove ~/.Xresources [y/N]: "
    read rm_xres
    [ "${rm_xres/Y/y}" == "y" ] && rm $HOME/.Xresources && echo "Removed $HOME/.Xresources"
else
    echo "Path does not exist $HOME/.Xresources"
fi

_unlink $HOME/.mozilla/firefox/*.default/chrome/userChrome.css
