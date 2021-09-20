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
          helper = pkgs.writeShellScript "credential-helper-github" ''
            if [ "$1" = get ]; then
              echo "password=$(${pkgs.libressl}/bin/openssl aes-256-cbc -d \
                -in ~/.config/secrets/github \
                -pass file:<(${config.programs.ssh.askPassword}))"
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
        };
        user = {
          name = "figsoda";
          email = "figsoda@pm.me";
        };
      };
    };
    ssh.askPassword = "${pkgs.writeShellScript "password-prompt" ''
      ${pkgs.yad}/bin/yad --title "Password prompt" \
        --fixed --on-top --center \
        --entry --hide-text
    ''}";
    steam.enable = true;
  };
}
