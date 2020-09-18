#!/bin/bash

xbps-install -Syu
xbps-install -y void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree

while IFS= read -r pkgs; do
    [ -n "$pkgs" ] && xbps-install -y "$pkgs"
done < xbps-pkgs.txt

rustup toolchain install nightly --components clippy rustfmt
cargo install cargo-audit cargo-bloat cargo-cache cargo-udeps cargo-update cross pactorio

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak override --filesystem=~/.icons/:ro --user
flatpak install com.discordapp.Discord

eval "$(curl -L https://nixos.org/nix/install)" --no-daemon
eval "$(curl -L https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
