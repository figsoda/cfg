{ config, lib, pkgs, ... }:

with pkgs;

let
  inherit (builtins) concatStringsSep;
  inherit (lib) mapAttrsFlatten;
in

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
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

      bind \cl "${ncurses}/bin/clear; fish_prompt"

      function __fish_command_not_found_handler -e fish_command_not_found -a cmd
        history merge
        history delete -Ce $history[1]
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

      function path -a name
        ${coreutils}/bin/realpath (${which}/bin/which $name)
      end

      function w
        if set -q with_pkgs
          set with_pkgs ", $with_pkgs"
        end
        set -lx with_pkgs "$argv$with_pkgs"
        IN_NIX_SHELL=impure name="with: $with_pkgs" \
          ${config.nix.package}/bin/nix shell nixpkgs#$argv
      end
    '';

    loginShellInit = ''
      if not set -q DISPLAY && [ (${coreutils}/bin/tty) = /dev/tty1 ]
        exec ${
          sx.override {
            xorgserver = writeShellScriptBin "Xorg" ''
              exec ${xorg.xorgserver}/bin/Xorg -ardelay 320 -arinterval 32 "$@"
            '';
          }
        }/bin/sx ${
          writeShellScript "sxrc" ''
            CM_MAX_CLIPS=20 CM_SELECTIONS=clipboard ${clipmenu}/bin/clipmenud &
            ${config.passthru.element-desktop}/bin/element-desktop --hidden &
            ${config.i18n.inputMethod.package}/bin/fcitx5 &
            ${mpd}/bin/mpd &
            ${networkmanagerapplet}/bin/nm-applet &
            ${spaceFM}/bin/spacefm -d &
            ${unclutter-xfixes}/bin/unclutter --timeout 3 &
            ${volctl}/bin/volctl &
            ${xdg-user-dirs}/bin/xdg-user-dirs-update &
            ${xss-lock}/bin/xss-lock --ignore-sleep ${config.passthru.lockscreen}/bin/lockscreen &
            exec ${config.services.xserver.windowManager.awesome.package}/bin/awesome
          ''
        }
      end
    '';

    shellAbbrs = {
      c = "cargo";
      cb = "cargo build";
      cbr = "cargo build --release";
      cl = "cargo clippy";
      cr = "cargo run";
      crr = "cargo run --release";
      ct = "cargo test";
      g = "git";
      ga = "git add";
      gb = " git branch";
      gc = "git commit";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gcb = " git checkout -b";
      gcl = " git clone";
      gco = "git checkout";
      gcp = " git cherry-pick";
      gd = "git diff";
      gdc = "git diff --cached";
      gf = "git fetch";
      gff = "git pull --ff-only";
      gfu = "git fetch upstream";
      gl = "git log";
      gm = "git merge";
      gp = "git push";
      gpf = "git push -f";
      gpm = "git pull";
      gpr = "git pull --rebase";
      gpu = "git push -u origin (git branch --show-current)";
      gr = "git reset";
      grb = "git rebase -i";
      gre = "git restore";
      gs = "git status";
      gs- = "git switch -";
      gsc = " git switch -c";
      gsp = "git stash pop";
      gst = "git stash";
      gsw = "git switch";
      gt = " git tag";
      n = "nix";
      n-b = "nix-build";
      n-s = "nix-shell";
      nb = "nix build";
      nba = "nix-build -A";
      nd = "nix develop -c fish";
      nf = "nix flake";
      nfu = "nix flake update";
      nh = "nixpkgs-hammer";
      npu = " nix-prefetch-url --unpack";
      nr = "nix run";
      nrh = "nixpkgs-review rev HEAD";
      nrp = " GITHUB_TOKEN=(ghtok) nixpkgs-review pr";
      ns = "nix shell";
      nu = "nix-update";
      nuc = "nix-update --commit";
      nucb = "nix-update --commit --build";
      r = " r";
      vpu = " GITHUB_API_TOKEN=(ghtok | psub) pkgs/misc/vim-plugins/update.py";
      w = " w";
    };

    shellAliases = {
      cp = "${coreutils}/bin/cp -ir";
      ls =
        "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
      mv = "${coreutils}/bin/mv -i";
      rm = "${coreutils}/bin/rm -I";
    };

    useBabelfish = true;
  };
}
