{ config, pkgs, ... }: {
  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    git = {
      enable = true;
      config = {
        core.pager = "${pkgs.delta}/bin/delta";
        credential."https://github.com" = {
          username = "figsoda";
          helper = pkgs.writers.writeBash "credential-helper-github" ''
            if [ "$1" = get ]; then
              echo -n password=
              ${pkgs.libsecret}/bin/secret-tool lookup github git
            fi
          '';
        };
        delta = {
          hunk-header-decoration-style = "blue";
          line-number = true;
          syntax-theme = "OneHalfDark";
        };
        init.defaultBranch = "main";
        interactive.diffFilter = "${pkgs.delta}/bin/delta --color-only";
        url = {
          "https://gitlab.com/".insteadOf = [ "gl:" "gitlab:" ];
          "https://github.com/".insteadOf = [ "gh:" "github:" ];
          "https://github.com/figsoda/".insteadOf = [ "me:" ];
          "https://github.com/nix-community/".insteadOf = [ "nc:" ];
        };
        user = {
          name = "figsoda";
          email = "figsoda@pm.me";
        };
      };
    };
    ssh = {
      askPassword = "${pkgs.writers.writeDash "password-prompt" ''
        ${pkgs.yad}/bin/yad --title "Password prompt" \
          --fixed --on-top --center \
          --entry --hide-text
      ''}";
      knownHosts = {
        "aarch64.nixos.community".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMUTz5i9u5H2FHNAmZJyoJfIGyUm/HfGhfwnc142L3ds";
        "darwin-build-box.winter.cafe".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB0io9E0eXiDIEHvsibXOxOPveSjUPIr1RnNKbUkw3fD";
      };
    };
    starship = {
      enable = true;
      settings = {
        cmd_duration.min_time = 1000;
        command_timeout = 1000;
        directory = {
          fish_style_pwd_dir_length = 1;
          read_only = " ";
          truncate_to_repo = false;
        };
        format = ''
          $username$directory$git_branch$git_commit$git_state$git_status$nix_shell$cmd_duration
          $jobs$battery$status$character
        '';
        nix_shell.symbol = " ";
      };
    };
    steam.enable = true;
  };
}
