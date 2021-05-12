{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "rofi-todo" ''
      ${pkgs.rofi}/bin/rofi -show todo -modi todo:${
        writeShellScript "todo-modi" ''
          todos=~/.local/share/todos
          mkdir -p ~/.local/share
          touch "$todos"

          [ -z "$1" ] && ${coreutils}/bin/cat "$todos" && exit 0

          if item=$(${ripgrep}/bin/rg '^\+\s*([^\s](.*[^\s])?)\s*$' -r '$1' <<< "$1"); then
            ${coreutils}/bin/sort "$todos" - -uo "$todos" <<< "$item"
          else
            while read -r line; do
              [ "$line" = "$1" ] || echo "$line"
            done < "$todos" | ${moreutils}/bin/sponge "$todos"
          fi
        ''
      }
    '')
    (writeTextDir "/share/icons/default/index.theme" ''
      [icon theme]
      Inherits=Qogir
    '')
    alacritty
    bat
    binutils
    bottom
    cargo-edit
    cargo-play
    clipmenu
    fd
    firefox
    fzf
    gcc
    gimp
    git
    gitAndTools.delta
    libressl
    llvmPackages_latest.lld
    luaformatter
    maim
    mmtc
    mpc_cli
    (mpv.override {
      scripts = with mpvScripts; [ autoload sponsorblock thumbnail ];
    })
    newsflash
    nixfmt
    onlyoffice-bin
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
    (with fenix;
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
      vscode = vscodium;
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
    ymdl
  ];
}
