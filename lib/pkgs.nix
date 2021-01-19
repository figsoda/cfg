{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
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
    fzf
    gcc
    gimp
    git
    gitAndTools.delta
    libreoffice-fresh
    libressl
    luaformatter
    maim
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
        a5huynh.vscode-ron
        jnoortheen.nix-ide
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
}
