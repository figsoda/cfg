#!/bin/bash

src=$(realpath $(dirname ${BASH_SOURCE[0]}))/src

symlink() {
    $3 rm $2/$1
    $3 ln -s $src/$1 $2
}

symlink .bashrc ~
symlink .xbindkeysrc ~
symlink flameshot.ini ~/.config/Dharkael
symlink justfile ~
symlink resolv.conf /etc sudo
