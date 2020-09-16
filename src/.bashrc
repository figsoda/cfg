[[ $- != *i* ]] && return

export VERSION_ID=unavailable

alias ls="ls --color=auto"
alias code=code-oss

source ~/.nix-profile/etc/profile.d/nix.sh
eval "$(thefuck --alias)"
eval "$(starship init bash)"
