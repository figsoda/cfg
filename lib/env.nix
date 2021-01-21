{ pkgs, ... }: {
  environment = {
    etc = {
      gitconfig.text = ''
        [core]
        pager = ${pkgs.gitAndTools.delta}/bin/delta

        [delta]
        hunk-header-decoration-style = blue
        line-numbers = true
        syntax-theme = OneHalfDark

        [init]
        defaultBranch = main

        [interactive]
        diffFilter = delta --color-only

        [user]
        name = figsoda
        email = figsoda@pm.me

        [credential "https://github.com/"]
        username = figsoda
        helper = ${
          pkgs.writeShellScript "credential-helper-github" ''
            if [ "$1" = get ]; then
              echo "password=$(${pkgs.libressl}/bin/openssl aes-256-cbc \
                -d -in ~/.config/secrets/github -pass file:<($SSH_ASKPASS))"
            fi
          ''
        }

        [url "https://github.com/"]
        insteadOf = gh:
        insteadOf = github:
      '';
      "resolv.conf".text = ''
        nameserver 1.1.1.1
        nameserver 1.0.0.1
      '';
      "xdg/mimeapps.list".text = ''
        [Default Applications]
        application/pdf=firefox.desktop
        image/bmp=sxiv.desktop
        image/gif=sxiv.desktop
        image/jpeg=sxiv.desktop
        image/jpg=sxiv.desktop
        image/png=sxiv.desktop
        image/tiff=sxiv.desktop
        image/x-bmp=sxiv.desktop
        image/x-portable-anymap=sxiv.desktop
        image/x-portable-bitmap=sxiv.desktop
        image/x-portable-graymap=sxiv.desktop
        image/x-tga=sxiv.desktop
        image/x-xpixmap=sxiv.desktop
        inode/directory=spacefm.desktop
      '';
    };
    variables = {
      LESSHISTFILE = "-";
      PATH = "$HOME/.cargo/bin";
      RIPGREP_CONFIG_PATH = "${pkgs.writeText "rg-config" ''
        -S
        -g=!.git
        --hidden
      ''}";
    };
  };
}
