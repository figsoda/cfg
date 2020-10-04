#!/bin/bash

xbps-install -Suy void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
xbps-install -Suy $(cat xbps-pkgs.txt)

ln -st /var/service /etc/sv/{NetworkManager,bluetoothd,chronyd,dbus,docker,elogind}
touch /etc/sv/docker/down

rustup-init -y --default-toolchain nightly -c clippy rustfmt
~/.cargo/bin/cargo install cargo-audit cargo-bloat cargo-cache cargo-udeps cargo-update cross pactorio

. <(curl -L https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)

src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/src"

while IFS=" " read -r file dir; do
    dir="$(eval echo "$dir")"
    if [ -n "$file" ] && [ -n "$dir" ]; then
        [ -f "$dir/$file" ] && rm "$dir/$file"
        [ ! -d "$dir" ] && mkdir -p "$dir"
        ln -s "$src/$file" -t "$dir"
    fi
done < symlinks.txt
