[[ $- != *i* ]] && return

alias ls="ls --color=auto"

PS1='[\u@\h \W]\$ '

export VERSION_ID=unavailable
export XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share

alias code="code-oss"

source ~/.nix-profile/etc/profile.d/nix.sh
eval "$(thefuck --alias)"
eval "$(starship init bash)"
