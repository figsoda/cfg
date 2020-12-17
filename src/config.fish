if [ -z $DISPLAY ] && [ (tty) = /dev/tty1 ]
    exec startx -- -ardelay 400 -arinterval 32
end

set fish_color_autosuggestion 005f5f
set fish_color_cancel normal
set fish_color_command 00afff
set fish_color_comment 626262
set fish_color_cwd 008000
set fish_color_cwd_root 800000
set fish_color_end d75fff
set fish_color_error ff0000
set fish_color_escape 00a6b2
set fish_color_history_current normal
set fish_color_host normal
set fish_color_match normal
set fish_color_normal normal
set fish_color_operator 00a6b2
set fish_color_param 87d7d7
set fish_color_quote 5fd700
set fish_color_redirection ff8700
set fish_color_search_match ffff00
set fish_color_selection c0c0c0
set fish_color_user 00ff00
set fish_color_valid_path normal
set fish_greeting
set fish_pager_color_completion normal
set fish_pager_color_description B3A06D yellow
set fish_pager_color_prefix white --bold --underline
set fish_pager_color_progress brwhite --background=cyan

abbr -ag nb nix-build
abbr -ag ni nix-env -iA
abbr -ag npu nix-prefetch-url
abbr -ag nr nix-env -e
abbr -ag ns nix-shell
abbr -ag nsf nix-shell --run fish -p

alias ls "exa -bl --git --icons --time-style long-iso --group-directories-first"
alias redo 'eval sudo $history[1]'
alias rm "rm -I"

function gen -a template name
    string length -q -- $template $name
    sh ~/rust-templates/gen.sh ~/rust-templates/$template \
        $name $name '["figsoda <figsoda@pm.me>"]' figsoda/$name
end

starship init fish | .
