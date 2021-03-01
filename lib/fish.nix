{ config, lib, pkgs, ... }: {
  programs.fish = with pkgs; {
    enable = true;
    interactiveShellInit = with lib; ''
      source ${
        runCommand "starship-init-fish" { STARSHIP_CACHE = ".cache"; }
        "${starship}/bin/starship init fish --print-full-init > $out"
      }

      ${concatStringsSep "\n" (mapAttrsFlatten (k: v: "set -g fish_${k} ${v}") {
        color_autosuggestion = "606886";
        color_cancel = "e06c75";
        color_command = "61afef -o";
        color_comment = "5c6370 -i";
        color_cwd = "98c379";
        color_cwd_root = "61afef";
        color_end = "9ab5e4";
        color_error = "f83c40";
        color_escape = "56b6c2";
        color_history_current = "e5c07b -o";
        color_host = "61afef";
        color_host_remote = "61afef";
        color_match = "56b6c2";
        color_normal = "abb2bf";
        color_operator = "56b6c2";
        color_param = "9ab5e4";
        color_quote = "98c379";
        color_redirection = "c678dd";
        color_search_match = "e5c07b";
        color_selection = "2c323c";
        color_status = "e06c75";
        color_user = "e5c07b";
        color_valid_path = "e5c07b";
        greeting = "";
        pager_color_background = "";
        pager_color_completion = "abb2bf";
        pager_color_description = "98c379";
        pager_color_prefix = "abb2bf -o";
        pager_color_progress = "e5c07b";
        pager_color_selected_completion = "61afef -o";
        pager_color_selected_description = "e5c07b";
        pager_color_selected_prefix = "61afef -o -u";
      })}

      ${concatStringsSep "\n"
      (mapAttrsFlatten (k: v: "set -gx LESS_TERMCAP_${k} ${v}") {
        md = ''\e"[1m"\e"[38;2;97;175;239m"'';
        ue = ''\e"[0m"'';
        us = ''\e"[38;2;209;154;102m"'';
      })}

      ${concatStringsSep "\n"
      (mapAttrsFlatten (k: v: "abbr -ag ${k} ${escapeShellArg v}") {
        gb = "git branch";
        gc = "git commit";
        gcb = "git checkout -b";
        gco = "git checkout";
        gcp = "git commit -p";
        gff = "git pull --ff-only";
        gp = "git push";
        nb = "nix build";
        nd = "nix develop -c fish";
        ne = "nix-env";
        nei = "nix-env -f '<nixos>' -iA";
        ner = "nix-env -e";
        nf = "nix flake";
        nfu = "nix flake update";
        npu = "nix-prefetch-url";
        ns = "nix shell";
      })}

      function __fish_command_not_found_handler -e fish_command_not_found -a cmd
        history delete --case-sensitive --exact "$argv"
        if [ -d $cmd ]
          echo "fish: Entering directory: $cmd" >&2
          cd $cmd
        else
          echo "fish: Unknown command: $cmd" >&2
        end
      end

      function f -a lang
        switch $lang
          case lua
            ${fd}/bin/fd -H '\.lua$' -x ${luaformatter}/bin/lua-format -i
          case nix
            ${fd}/bin/fd -H '\.nix$' -x ${nixfmt}/bin/nixfmt
          case rust
            cargo fmt
          case "*"
            echo "unexpected language: $lang"
        end
      end

      function gen -a template name
        string length -q -- $template $name
        ~/rust-templates/gen.sh ~/rust-templates/$template \
          $name $name '["figsoda <figsoda@pm.me>"]' figsoda/$name
      end

      function with
        IN_NIX_SHELL=impure name="with: "(string join ", " $argv) \
          ${config.nix.package}/bin/nix shell --inputs-from /etc/nixos nixpkgs#$argv
      end
    '';
    loginShellInit = ''
      if not set -q DISPLAY && [ (${coreutils}/bin/tty) = /dev/tty1 ]
        exec ${xorg.xinit}/bin/startx ${
          writeText "xinitrc" ''
            CM_MAX_CLIPS=20 CM_SELECTIONS=clipboard ${clipmenu}/bin/clipmenud &
            ${mpd}/bin/mpd &
            ${networkmanagerapplet}/bin/nm-applet &
            ${spaceFM}/bin/spacefm -d &
            ${unclutter-xfixes}/bin/unclutter --timeout 3 &
            ${volctl}/bin/volctl &
            [ -e /tmp/xidlehook.sock ] && ${coreutils}/bin/rm /tmp/xidlehook.sock
            ${xidlehook}/bin/xidlehook --socket /tmp/xidlehook.sock \
              --timer 900 ${
                writeShellScript "lockscreen" ''
                  ${xorg.xset}/bin/xset dpms force standby &
                  ${i3lock-color}/bin/i3lock-color \
                    -i ~/.config/wallpaper.png -k \
                    --{inside{ver,wrong,},ring,line,separator}color=00000000 \
                    --ringvercolor=98c379 --ringwrongcolor=f83c40 \
                    --keyhlcolor=61afef --bshlcolor=d19a66 \
                    --verifcolor=98c379 --wrongcolor=f83c40 \
                    --indpos=x+w/7:y+h-w/8 \
                    --{time,date}-font=monospace \
                    --{layout,verif,wrong,greeter}size=32 \
                    --timecolor=61afef --timesize=36 \
                    --datepos=ix:iy+36 --datecolor=98c379 --datestr=%F --datesize=28 \
                    --veriftext=Verifying... \
                    --wrongtext="Try again!" \
                    --noinputtext="No input" \
                    --locktext=Locking... --lockfailedtext="Lock failed!" \
                    --radius 108 --ring-width 8
                ''
              } "" \
              --timer 12000 "${config.systemd.package}/bin/systemctl suspend" "" &
            exec ${awesome}/bin/awesome
          ''
        } -- -ardelay 400 -arinterval 32
      end
    '';
    shellAliases = {
      cp = "${coreutils}/bin/cp -ir";
      ls =
        "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
      mv = "${coreutils}/bin/mv -i";
      rm = "${coreutils}/bin/rm -I";
    };
  };
}
