#!/usr/bin/env bash

echo Installing rust toolchain
rustup toolchain install nightly

echo Installing cargo packages
cargo install mmtc pactorio

echo Downloading wallpaper
mkdir -p ~/.config/wallpaper
curl -LSso ~/.config/wallpaper/original.png\
    https://github.com/dracula/wallpaper/raw/master/linux.png

echo Resizing wallpaper
res="$(xrandr | rg "\*" | sd ".*?(\d+x\d+).*" '$1')"
convert ~/.config/wallpaper/original.png\
    -resize "$res^"\
    -gravity center\
    -extent "$res"\
    ~/.config/wallpaper/resized.png

echo Configuring mpd
mkdir -p ~/music ~/.local/share/mpd/playlists
touch ~/.local/share/mpd/mpd.db

echo Creating symlinks
src="$(realpath "$(dirname "${BASH_SOURCE[0]}")")/src"
while IFS=" " read -r file d; do
    dir="$(eval echo "$d")"
    if [ -n "$file" ] && [ -n "$dir" ]; then
        [ -e "$dir/$file" ] && rm -r "$dir/$file"
        [ -d "$dir" ] || mkdir -p "$dir"
        ln -s "$src/$file" -t "$dir"
    fi
done < symlinks.txt
