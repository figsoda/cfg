#!/bin/bash

xbps-install -Suy void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
xbps-install -Suy $(cat xbps-pkgs.txt)

ln -st /var/service /etc/sv/{NetworkManager,bluetoothd,chronyd,dbus,docker,elogind}
touch /etc/sv/docker/down

rustup-init -y --default-toolchain nightly -c clippy rustfmt
~/.cargo/bin/cargo install cargo-audit cargo-bloat cargo-cache cargo-udeps cargo-update cross pactorio

for f in Bold-Italic Bold ExtraBold-Italic ExtraBold Italic Medium-Italic Medium Regular; do
    curl -LSso "$HOME/.local/share/fonts/JetBrains Mono ${f/-/ } Nerd Font Complete.ttf"\
        "https://github.com/ryanoasis/nerd-fonts/raw/2.1.0/patched-fonts/JetBrainsMono/$f/complete/JetBrains%20Mono%20${f/-/%20}%20Nerd%20Font%20Complete.ttf"
done

for f in Bold-Italic Bold Italic Regular; do
    curl -LSso "$HOME/.local/share/fonts/Arimo ${f/-/ } Nerd Font Complete.ttf"\
        "https://github.com/ryanoasis/nerd-fonts/raw/2.1.0/patched-fonts/Arimo/$f/complete/Arimo%20${f/-/%20}%20Nerd%20Font%20Complete.ttf"
done

src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/src"

while IFS=" " read -r file dir; do
    dir="$(eval echo "$dir")"
    if [ -n "$file" ] && [ -n "$dir" ]; then
        [ -f "$dir/$file" ] && rm "$dir/$file"
        [ ! -d "$dir" ] && mkdir -p "$dir"
        ln -s "$src/$file" -t "$dir"
    fi
done < symlinks.txt

fc-cache
