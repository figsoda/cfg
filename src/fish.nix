{ config, lib, pkgs, ... }:

with pkgs;

let
  inherit (builtins) concatStringsSep;
  inherit (lib) mapAttrsFlatten removePrefix;
in

{
  environment.systemPackages = with fishPlugins; [
    async-prompt
    autopair
  ];

  programs.fish = {
    enable = true;

    shellInit = ''
      ${starship}/bin/starship init fish | source
    '';

    interactiveShellInit = with import ./colors.nix; ''
      ${concatStringsSep "\n" (mapAttrsFlatten (k: v: "set -g fish_${k} ${removePrefix "#" v}") {
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
        ${coreutils}/bin/realpath (command -v $name)
      end

      function w
        if set -q with_pkgs
          set with_pkgs ", $with_pkgs"
        end
        set -lx with_pkgs "$argv$with_pkgs"
        IN_NIX_SHELL=impure name="with: $with_pkgs" \
          ${config.nix.package}/bin/nix shell nixpkgs#$argv -c ${fish}/bin/fish
      end
    '';

    loginShellInit = ''
      if not set -q DISPLAY && [ (${coreutils}/bin/tty) = /dev/tty1 ]
        exec ${
          sx.override {
            xorg = xorg // {
              xorgserver = writers.writeDashBin "Xorg" ''
                exec ${xorg.xorgserver}/bin/Xorg -ardelay 320 -arinterval 32 "$@"
              '';
            };
          }
        }/bin/sx ${
          writers.writeDash "sxrc" ''
            CM_MAX_CLIPS=100 CM_SELECTIONS=clipboard ${clipmenu}/bin/clipmenud &
            ${element-desktop}/bin/element-desktop --hidden &
            ${config.i18n.inputMethod.package}/bin/fcitx5 &
            ${mpd}/bin/mpd ${writeText "mpd.conf" ''
              music_directory "~/music"
              db_file "~/.local/share/mpd/mpd.db"
              pid_file "~/.local/share/mpd/mpd.pid"
              state_file "~/.local/share/mpd/mpdstate"
              bind_to_address "127.0.0.1"
              restore_paused "yes"
              audio_output {
                  type "pipewire"
                  name "Music Player Daemon"
              }
            ''} &
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
      cir = "cargo insta review";
      cit = "cargo insta test";
      cl = "cargo clippy";
      cn = "cargo nextest run";
      cr = "cargo run";
      crr = "cargo run --release";
      ct = "cargo test";
      g = "git";
      ga = "git add";
      gab = "git absorb -r";
      gb = " git branch";
      gbs = "git bisect";
      gc = "git commit";
      gca = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gcb = " git checkout -b";
      gcl = " git clone";
      gco = "git checkout";
      gcp = " git cherry-pick";
      gd = "git diff";
      gdc = "git diff --cached";
      gdh = "git diff HEAD";
      gf = "git fetch";
      gff = "git pull --ff-only";
      gffu = "git pull --ff-only upstream (git branch --show-current)";
      gfu = "git fetch upstream";
      gl = "git log";
      gm = "git merge";
      gp = "git push";
      gpf = "git push -f";
      gpm = "git pull";
      gpr = "git pull --rebase";
      gpu = "git push -u origin (git branch --show-current)";
      gr = "git reset";
      grb = "git rebase";
      gre = "git restore";
      gro = "git reabse --onto";
      gs = "git status";
      gs- = "git switch -";
      gsC = " git switch -C";
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
      nfc = "nix flake check";
      nfs = "nix flake show";
      nfu = "nix flake update";
      nfuc = "nix flake update --commit-lock-file";
      nh = "nixpkgs-hammer";
      ni = "nix-init";
      npu = " nix-prefetch-url --unpack";
      nr = "nix run";
      nra = "nixpkgs-review approve";
      nram = "nixpkgs-review approve && nixpkgs-review merge";
      nrh = "nixpkgs-review rev HEAD";
      nrm = "nixpkgs-review merge";
      nrp = " GITHUB_TOKEN=(ghtok) nixpkgs-review pr";
      nrpam = "nixpkgs-review post-result && nixpkgs-review approve && nixpkgs-review merge";
      nrpr = "nixpkgs-review post-result";
      ns = "nix shell";
      nu = "nix-update";
      nuc = "nix-update --commit";
      nucb = "nix-update --commit --build";
      r = " r";
      vpu = " pkgs/applications/editors/vim/plugins/update.py -t (ghtok | psub)";
      w = " w";
    };

    shellAliases = {
      cp = "${coreutils}/bin/cp -ir";
      ls = "${exa}/bin/exa -bl --git --icons --time-style long-iso --group-directories-first";
      mv = "${coreutils}/bin/mv -i";
      rm = "${coreutils}/bin/rm -I";
    };

    useBabelfish = true;
  };
}
