#!/bin/bash

xbps-install -Syu
xbps-install -y void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree

while IFS= read -r pkgs; do
    [ -n "$pkgs" ] && xbps-install -y "$pkgs"
done < xbps-pkgs.txt

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install com.discordapp.Discord

eval "$(curl -L https://nixos.org/nix/install)" --no-daemon
eval "$(curl -L https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
