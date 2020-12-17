if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    exec startx -- -ardelay 400 -arinterval 32
end

abbr -ag nb nix-build
abbr -ag ne nix-env
abbr -ag nei nix-env -iA
abbr -ag ner nix-env -e
abbr -ag npu nix-prefetch-url
abbr -ag ns nix-shell
abbr -ag nsf nix-shell --run fish -p

alias ls "exa -bl --git --icons --time-style long-iso --group-directories-first"
alias redo 'eval sudo $history[1]'
alias rm "rm -I"

set -g fish_greeting

set -g fish_color_normal normal
set -g fish_color_command 00afff
set -g fish_color_quote 5fd700
set -g fish_color_redirection ff8700
set -g fish_color_end d75fff
set -g fish_color_error ff0000
set -g fish_color_param 87d7d7
set -g fish_color_selection c0c0c0
set -g fish_color_search_match ffff00
set -g fish_color_history_current normal
set -g fish_color_operator 00a6b2
set -g fish_color_escape 00a6b2
set -g fish_color_cwd 008000
set -g fish_color_cwd_root 800000
set -g fish_color_valid_path normal
set -g fish_color_autosuggestion 005f5f
set -g fish_color_user 00ff00
set -g fish_color_host normal
set -g fish_color_cancel normal
set -g fish_pager_color_completion normal
set -g fish_pager_color_description B3A06D yellow
set -g fish_pager_color_prefix white --bold --underline
set -g fish_pager_color_progress brwhite --background=cyan
set -g fish_color_comment 626262
set -g fish_color_match normal

function gen -a template name
    string length -q -- $template $name
    sh ~/rust-templates/gen.sh ~/rust-templates/$template \
        $name $name '["figsoda <figsoda@pm.me>"]' figsoda/$name
end

starship init fish | .
