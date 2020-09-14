#!/bin/bash

src=$(realpath $(dirname ${BASH_SOURCE[0]}))/src

symlink() {
    if [ -f $2/$1 ]; then
        $3 rm $2/$1
    fi

    if [ ! -d $2 ]; then
        $3 mkdir -p $2
    fi

    $3 ln -s $src/$1 -t $2
}

symlink .bashrc ~
symlink .xbindkeysrc ~
symlink config.nix ~/.config/nixpkgs
symlink flameshot.ini ~/.config/Dharkael
symlink justfile ~
symlink resolv.conf /etc sudo
