export VERSION_ID=unavailable
export XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share

alias code=code-oss

bash ~/.nix-profile/etc/profile.d/nix.sh
thefuck --alias | source
starship init fish | source
