#!/bin/bash

xbps-install -Suy
xbps-install -y void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree

while IFS= read -r pkgs; do
    [ -n "$pkgs" ] && xbps-install -y $pkgs
done < xbps-pkgs.txt

ln -st /var/service /etc/sv/{NetworkManager,bluetoothd,chronyd,dbus,docker,elogind}
touch /etc/sv/docker/down

rustup-init -y --default-toolchain nightly -c clippy rustfmt
bash ~/.cargo/env
cargo install cargo-audit cargo-bloat cargo-cache cargo-udeps cargo-update cross pactorio

bash <(curl -L https://nixos.org/nix/install) --no-daemon
bash <(curl -L https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)

src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/src"

while IFS=" " read -r file dir sudo; do
    dir="$(eval echo "$dir")"
    if [ -n "$file" ] && [ -n "$dir" ]; then
        [ -f "$dir/$file" ] && $sudo rm "$dir/$file"
        [ ! -d "$dir" ] && $sudo mkdir -p "$dir"
        echo "ln -s \"$src/$file\" -t \"$dir\""
        $sudo ln -s "$src/$file" -t "$dir"
    fi
done < symlinks.txt
