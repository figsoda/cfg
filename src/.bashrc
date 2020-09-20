[[ $- != *i* ]] && return

export EDITOR=code-oss
export VERSION_ID=unavailable

alias ls="exa -bl --git --time-style long-iso --group-directories-first"
alias code=code-oss

source /home/figsoda/.config/broot/launcher/bash/br
source ~/.nix-profile/etc/profile.d/nix.sh
eval "$(thefuck --alias)"
eval "$(starship init bash)"
