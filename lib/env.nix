{ pkgs, ... }: {
  environment = {
    etc = {
      gitconfig.text = ''
        [user]
        name = figsoda
        email = figsoda@pm.me

        [credential "https://github.com"]
        username = figsoda
        helper = ${
          pkgs.writeShellScript "credential-helper-github" ''
            if [ "$1" = get ]; then
              echo "password=$(${pkgs.libressl}/bin/openssl \
                aes-256-cbc -d -in ~/.config/secrets/github)"
            fi
          ''
        }
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
    systemPackages = with pkgs; [
      (writeTextDir "/share/icons/default/index.theme" ''
        [icon theme]
        Inherits=Qogir
      '')
      alacritty
      bat
      bottom
      cargo-edit
      clipmenu
      fd
      firefox
      gcc
      gimp
      git
      libreoffice-fresh
      libressl
      luaformatter
      maim
      micro
      mmtc
      mpc_cli
      (mpv.override { scripts = with mpvScripts; [ autoload sponsorblock ]; })
      nixfmt
      pamixer
      papirus-icon-theme
      pavucontrol
      psmisc
      python3
      qalculate-gtk
      qogir-icon-theme
      qogir-theme
      ripgrep
      (rofi.override { plugins = [ rofi-calc rofi-emoji ]; })
      (with rust-nightly;
        combine (with default; [
          cargo
          clippy-preview
          rust-std
          rustc
          rustfmt-preview
          latest.rust-src
        ]))
      sd
      spaceFM
      sxiv
      rnix-lsp
      (vscode-with-extensions.override {
        vscode = vscodium.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ jq moreutils ];
          installPhase = ''
            jq -e '.extensionsGallery = {
              "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
              "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
              "itemUrl": "https://marketplace.visualstudio.com/items",
            }' resources/app/product.json | sponge resources/app/product.json
          '' + old.installPhase;
        });
        vscodeExtensions = with vscode-extensions; [
          (vscode-utils.extensionFromVscodeMarketplace {
            publisher = "jnoortheen";
            name = "nix-ide";
            version = "0.1.7";
            sha256 = "1bw4wyq9abimxbhl7q9g8grvj2ax9qqq6mmqbiqlbsi2arvk0wrm";
          })
          a5huynh.vscode-ron
          matklad.rust-analyzer-nightly
          mskelton.one-dark-theme
          naumovs.color-highlight
          pkief.material-icon-theme
          redhat.vscode-yaml
          serayuzgur.crates
          skyapps.fish-vscode
          tamasfe.even-better-toml
        ];
      })
      xidlehook
      xsel
      xtrt
    ];
    variables = {
      EDITOR = "micro";
      LESSHISTFILE = "-";
      PATH = "$HOME/.cargo/bin";
    };
  };
}