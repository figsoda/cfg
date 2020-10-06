#!/bin/bash

xbps-install -Suy void-repo-multilib void-repo-multilib-nonfree void-repo-nonfree
xbps-install -Suy $(< xbps-pkgs.txt)

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

# https://www.pling.com/p/1356095 volantes_cursors
tmp=$(mktemp)
mkdir ~/.icons
curl -LSso "$tmp"\
    https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1ODEyMzEwMzgiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6ImFiMzVlNzUxZjY5YTYyMTFiNGNjMjk5MTk4N2M2ODRlMGJhYTAxMjYyOWRhNTMwY2Q1NzEwNGNiM2QyZTEwYTFiNGU3Yjc3ZmNjNjYwYWYzYmQ0YWFiNTFiODJkZjJhNGU1MDlkZTI5ZmJhNTZhYjIzZjc1ZmYyN2JlNGI2OWY4IiwidCI6MTYwMTk0NTA0OCwic3RmcCI6IjllOGQ0NWE0NmYwZGVhMmRmOGIxMWZmMzc3ODEzY2VlIiwic3RpcCI6IjY3LjIwLjEyOC4xNDEifQ.MojUQyN2OqjrTLhGKIsWgPmM_MghLwrmVQYyyE4xUUc/volantes_cursors.tar.gz
tar xfz "$tmp" -C ~/.icons
unlink "$tmp"

# https://www.pling.com/p/1279924 Tela-dark
tmp=$(mktemp)
mkdir ~/.local/share/icons
curl -LSso "$tmp"\
    https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MDEyNzI4NzciLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6ImFjZDIxZDYwNTYxMmI4MzEzMGFkNTliNTAyZjE2ZWI4NTBhZjZmZDEzYzhiMTAyN2M5MzZiMTRjNGEyN2Y4N2E3ZjU2ZTRjMjg5NTVkNDkyOTBmZmQxMDBjMzU3N2MxMzYzZDlkOGE2MDJmNjAxNTdlMmQwMzdlNDFiYWNiNDE5IiwidCI6MTYwMTk0Nzc1Niwic3RmcCI6IjllOGQ0NWE0NmYwZGVhMmRmOGIxMWZmMzc3ODEzY2VlIiwic3RpcCI6IjY3LjIwLjEyOC4xNDEifQ.EZOJrBjpQHNR4-IlwPMojaN7J6W3lctmBYrgWBGLThQ/01-Tela.tar.xz
tar xfJ "$tmp" -C ~/.local/share/icons
unlink "$tmp"

# https://www.pling.com/p/1316887 Material-Black-Blueberry
tmp=$(mktemp)
mkdir ~/.themes
curl -LSso "$tmp"\
    https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MDAyNDUzOTEiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjI0YThmZTJjZDdjZmE2NzlhZmVjMWI0MTVkMjNkYTYzNzdkYzliNzY4OTZhM2Y4NTk2MDgzNDhiNzU3Y2MyNThmOWM0NzgyMTZhZDUyNDViMDlkNmEyNjYyMDI2YzQ3YTg3MjE3MGZlMzc1YThhNDJhNTdhNGU1NjAxNWNlMDlhIiwidCI6MTYwMTk0ODEyMiwic3RmcCI6IjllOGQ0NWE0NmYwZGVhMmRmOGIxMWZmMzc3ODEzY2VlIiwic3RpcCI6IjY3LjIwLjEyOC4xNDEifQ.5t5y5eY71QAq7BppDPsJHVis68XFCT86w4TC8ek-eMQ/Material-Black-Blueberry_1.8.8.zip
unzip -qq "$tmp" -d ~/.themes
unlink "$tmp"

curl -LSs https://github.com/dracula/wallpaper/raw/master/void.png -o ~/wallpaper.png

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
