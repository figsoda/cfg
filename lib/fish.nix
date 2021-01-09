{ config, lib, pkgs, ... }: {
  programs.fish = with pkgs; {
    enable = true;
    interactiveShellInit = with lib; ''
      source ${
        runCommand "starship-init-fish" { STARSHIP_CACHE = ".cache"; }
        "${starship}/bin/starship init fish --print-full-init > $out"
      }

      ${concatStringsSep "\n"
      (mapAttrsFlatten (k: v: "set -g fish_${k} ${escapeShellArg v}") {
        color_autosuggestion = "005f5f";
        color_cancel = "normal";
        color_command = "00afff";
        color_comment = "626262";
        color_cwd = "008000";
        color_cwd_root = "800000";
        color_end = "d75fff";
        color_error = "ff0000";
        color_escape = "00a6b2";
        color_history_current = "normal";
        color_host = "normal";
        color_match = "normal";
        color_normal = "normal";
        color_operator = "00a6b2";
        color_param = "87d7d7";
        color_quote = "5fd700";
        color_redirection = "ff8700";
        color_search_match = "ffff00";
        color_selection = "c0c0c0";
        color_user = "00ff00";
        color_valid_path = "normal";
        greeting = "";
        pager_color_completion = "normal";
        pager_color_description = "B3A06D yellow";
        pager_color_prefix = "white -ou";
        pager_color_progress = "brwhite -b cyan";
      })}

      ${concatStringsSep "\n"
      (mapAttrsFlatten (k: v: "abbr -ag ${k} ${escapeShellArg v}") {
        gc = "git commit";
        gco = "git checkout";
        gff = "git pull --ff-only";
        gp = "git push";
        nb = "nix build";
        nd = "nix develop";
        ne = "nix-env";
        nei = "nix-env -f '<nixos>' -iA";
        ner = "nix-env -e";
        nf = "nix flake";
        nfu = "nix flake update";
        npu = "nix-prefetch-url";
        ns = "nix-shell";
        nsf = "nix-shell --run fish -p";
      })}

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
              --not-when-audio \
              --timer 900 ${
                writeShellScript "lockscreen" ''
                  ${xorg.xset}/bin/xset dpms force standby &
                  ${i3lock-color}/bin/i3lock-color \
                    -i ~/.config/wallpaper.png -k \
                    --{inside{ver,wrong,},ring,line,separator}color=00000000 \
                    --ringvercolor=98c040 --ringwrongcolor=d02828 \
                    --keyhlcolor=2060a0 --bshlcolor=d06020 \
                    --verifcolor=b8f080 --wrongcolor=ff8080 \
                    --indpos=x+w/7:y+h-w/8 \
                    --{time,date}-font=monospace \
                    --{layout,verif,wrong,greeter}size=32 \
                    --timecolor=60b8ff --timesize=36 \
                    --datepos=ix:iy+36 --datecolor=e0a878 --datestr=%F --datesize=28 \
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
      cp = "${coreutils}/bin/cp -r";
      ls =
        "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
      rm = "${coreutils}/bin/rm -I";
    };
  };
}
