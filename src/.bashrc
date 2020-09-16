[[ $- != *i* ]] && return

export VERSION_ID=unavailable
export XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share

alias ls="ls --color=auto"
alias code=code-oss

source ~/.nix-profile/etc/profile.d/nix.sh
eval "$(thefuck --alias)"
eval "$(starship init bash)"
