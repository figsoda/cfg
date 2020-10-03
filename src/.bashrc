[[ $- != *i* ]] && return

. ~/.exports

alias ls="exa -bl --git --time-style long-iso --group-directories-first"
alias code=code-oss
alias bat="bat --style=numbers"

eval "$(starship init bash)"
