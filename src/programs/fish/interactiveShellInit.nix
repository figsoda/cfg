{ config, lib, pkgs, root }:

let
  inherit (builtins) concatStringsSep;
  inherit (lib) mapAttrsFlatten removePrefix;
  inherit (pkgs) coreutils fish rust-templates;

  nix = config.nix.package;
in

''
  ${concatStringsSep "\n" (mapAttrsFlatten
    (k: v: "set -g fish_${k} ${removePrefix "#" v}")
    (with root.colors; {
      color_autosuggestion = lightgray;
      color_cancel = red;
      color_command = "${blue} -o";
      color_comment = "${lightgray} -i";
      color_cwd = green;
      color_cwd_root = blue;
      color_end = white;
      color_error = lightred;
      color_escape = cyan;
      color_history_current = "${yellow} -o";
      color_host = blue;
      color_host_remote = blue;
      color_match = cyan;
      color_normal = white;
      color_operator = cyan;
      color_param = white;
      color_quote = green;
      color_redirection = magenta;
      color_search_match = yellow;
      color_selection = gray;
      color_status = red;
      color_user = yellow;
      color_valid_path = yellow;
      greeting = "";
      pager_color_background = "";
      pager_color_completion = white;
      pager_color_description = green;
      pager_color_prefix = "${white} -o";
      pager_color_progress = yellow;
      pager_color_selected_completion = "${blue} -o";
      pager_color_selected_description = yellow;
      pager_color_selected_prefix = "${blue} -o -u";
    }))}

  ${concatStringsSep "\n"
    (mapAttrsFlatten (k: v: "set -gx LESS_TERMCAP_${k} ${v}") {
      md = ''\e"[1m"\e"[38;2;97;175;239m"'';
      ue = ''\e"[0m"'';
      us = ''\e"[38;2;209;154;102m"'';
    })}

  abbr -ag --position anywhere -- "\ad" "--argstr system aarch64-darwin"
  abbr -ag --position anywhere -- "\al" "--argstr system aarch64-linux"
  abbr -ag --position anywhere -- "\xd" "--argstr system x86_64-darwin"

  function fish_command_not_found -a cmd
    history merge
    history delete -Ce -- $history[1]
    if [ -d $cmd ]
      echo "fish: Entering directory: $cmd" >&2
      cd $cmd
    else
      echo "fish: Unknown command: $cmd" >&2
    end
  end

  function gen -a tmpl name
    ${rust-templates}/bin/generate $tmpl $name $name '["figsoda <figsoda@pm.me>"]' figsoda/$name
    and cd $name
    and commandline "git push -u origin main"
  end

  function p -a name
    ${coreutils}/bin/realpath (command -v $name)
  end

  function w
    if set -q with_pkgs
      set with_pkgs ", $with_pkgs"
    end
    set -lx with_pkgs "$argv$with_pkgs"
    IN_NIX_SHELL=impure name="with: $with_pkgs" \
      ${nix}/bin/nix shell nixpkgs#$argv -c ${fish}/bin/fish
  end
''
