[[ $- != *i* ]] && return

. ~/.exports

alias ls="exa -bl --git --time-style long-iso --group-directories-first"
alias code=code-oss
alias bat="bat --style=numbers"
alias xr="sudo xbps-remove -R"

eval "$(starship init bash)"
