set -U fish_color_normal normal
set -U fish_color_command 00afff
set -U fish_color_quote 5fd700
set -U fish_color_redirection ff8700
set -U fish_color_end d75fff
set -U fish_color_error ff0000
set -U fish_color_param bcbcbc
set -U fish_color_selection c0c0c0
set -U fish_color_search_match ffff00
set -U fish_color_history_current normal
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd 008000
set -U fish_color_cwd_root 800000
set -U fish_color_valid_path normal
set -U fish_color_autosuggestion 005f5f
set -U fish_color_user 00ff00
set -U fish_color_host normal
set -U fish_color_cancel normal
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan
set -U fish_color_comment 626262
set -U fish_color_match normal

set -gx EDITOR code-oss
set -gx VERSION_ID unavailable

alias ls="exa -bl --git --time-style long-iso --group-directories-first"
alias code=code-oss

bash ~/.nix-profile/etc/profile.d/nix.sh
thefuck --alias | source
starship init fish | source
