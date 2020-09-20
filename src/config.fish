set EDITOR code-oss
set VERSION_ID unavailable

alias ls="exa -bl --git --time-style long-iso --group-directories-first"
alias code=code-oss

bash ~/.nix-profile/etc/profile.d/nix.sh
thefuck --alias | source
starship init fish | source
