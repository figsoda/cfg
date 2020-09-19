#!/bin/bash

xbps-install -Suy
xbps-install -y void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree

while IFS= read -r pkgs; do
    [ -n "$pkgs" ] && xbps-install -y $pkgs
done < xbps-pkgs.txt

ln -st /var/service /etc/sv/{NetworkManager,bluetoothd,chronyd,dbus,docker,sddm}
touch /etc/sv/docker/down

rustup-init -yt nightly -c clippy rustfmt
cargo install cargo-audit cargo-bloat cargo-cache cargo-udeps cargo-update cross pactorio

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak override --user --filesystem=~/.icons/:ro
flatpak install -y flathub com.discordapp.Discord

bash <(curl -L https://nixos.org/nix/install) --no-daemon
bash <(curl -L https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)
