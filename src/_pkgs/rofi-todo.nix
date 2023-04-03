{ config, pkgs, root }:

let
  inherit (pkgs) coreutils moreutils ripgrep rofi writers;
  inherit (root.pkgs) alacritty;

  neovim = config.programs.neovim.finalPackage;
in

writers.writeBashBin "rofi-todo" ''
  ${rofi}/bin/rofi -show todo -modes todo:${
    writers.writeBash "todo-mode" ''
      todos=~/.local/share/todos
      ${coreutils}/bin/mkdir -p ~/.local/share
      ${coreutils}/bin/touch "$todos"

      [ -z "$1" ] && ${coreutils}/bin/cat "$todos" && exit 0

      if [ "$1" = @ ]; then
        ${alacritty}/bin/alacritty -e ${neovim}/bin/nvim "$todos"
      elif item=$(${ripgrep}/bin/rg '^\+\s*([^\s](.*[^\s])?)\s*$' -r '$1' <<< "$1"); then
        ${coreutils}/bin/sort "$todos" - -uo "$todos" <<< "$item"
      else
        while read -r line; do
          [ "$line" = "$1" ] || echo "$line"
        done < "$todos" | ${moreutils}/bin/sponge "$todos"
      fi
    ''
  }
''
