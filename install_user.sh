#!/bin/bash

echo Installing rust toolchain
rustup-init -y --default-toolchain nightly -c clippy rustfmt

echo Installing cargo packages
~/.cargo/bin/cargo install cargo-audit cargo-cache cargo-edit cargo-update pactorio

mkdir -p ~/.local/share/fonts

echo Downloading JetBrains Mono Nerd Font
for f in Bold-Italic Bold ExtraBold-Italic ExtraBold Italic Medium-Italic Medium Regular; do
    curl -LSso "$HOME/.local/share/fonts/JetBrains Mono ${f/-/ } Nerd Font Complete.ttf"\
        "https://github.com/ryanoasis/nerd-fonts/raw/2.1.0/patched-fonts/JetBrainsMono/$f/complete/JetBrains%20Mono%20${f/-/%20}%20Nerd%20Font%20Complete.ttf"
done

echo Downloading Arimo Nerd Font
for f in Bold-Italic Bold Italic Regular; do
    curl -LSso "$HOME/.local/share/fonts/Arimo ${f/-/ } Nerd Font Complete.ttf"\
        "https://github.com/ryanoasis/nerd-fonts/raw/2.1.0/patched-fonts/Arimo/$f/complete/Arimo%20${f/-/%20}%20Nerd%20Font%20Complete.ttf"
done

pling() {
    tmp=$(mktemp)
    curl -LSso "$tmp" "$(
        curl -LSs "https://www.pling.com/p/$1" | sd -f s ".*download%2Fj%2F(.*)%2F$2.*"\
            "https://dllb2.pling.com/api/files/download/j/\$1/$2"
    )"
    echo "$tmp"
}

echo Downloading volantes_cursors cursor theme
tmp=$(pling 1356095 'volantes_cursors\.tar\.gz')
mkdir -p ~/.icons
tar xfz "$tmp" -C ~/.icons
unlink "$tmp"

echo Downloading Tela-dark icon theme
tmp=$(pling 1279924 '01-Tela\.tar\.xz')
mkdir -p ~/.local/share/icons
tar xfJ "$tmp" -C ~/.local/share/icons
unlink "$tmp"

echo Downloading Material-Black-Blueberry gtk theme
tmp=$(pling 1316887 'Material-Black-Blueberry_\d+\.\d+\.\d+.zip')
mkdir -p ~/.themes
unzip -qq "$tmp" -d ~/.themes
unlink "$tmp"

echo Downloading wallpaper
curl -LSs https://github.com/dracula/wallpaper/raw/master/void.png -o ~/wallpaper.png
