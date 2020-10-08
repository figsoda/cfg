[[ $- != *i* ]] && return

. ~/.aliases
. ~/.exports

eval "$(starship init bash)"
