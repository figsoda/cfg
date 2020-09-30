[[ $- != *i* ]] && return

export EDITOR=code-oss
export VERSION_ID=unavailable
export FZF_DEFAULT_OPTS="--preview \"bat --color=always --style=numbers {}\""

alias ls="exa -bl --git --time-style long-iso --group-directories-first"
alias code=code-oss
alias bat="bat --style=numbers"

source ~/.nix-profile/etc/profile.d/nix.sh
eval "$(thefuck --alias)"
eval "$(starship init bash)"
