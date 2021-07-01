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
    brightnessctl
    cargo-edit
    cargo-play
    clipmenu
    (element-desktop.override {
      element-web = element-web.override { conf.showLabSettings = true; };
    })
    fd
    (with fenix;
      combine (with default; [
        cargo
        clippy-preview
        rust-std
        rustc
        rustfmt-preview
        latest.rust-src
      ]))
    firefox
    fzf
    gcc
    gimp
    git
    gitAndTools.delta
    libreoffice-fresh
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
    nixpkgs-hammering
    pamixer
    pavucontrol
    psmisc
    python3
    qalculate-gtk
    qogir-icon-theme
    qogir-theme
    ripgrep
    rnix-lsp
    (rofi.override { plugins = [ rofi-calc ]; })
    sd
    spaceFM
    sxiv
    tela-icon-theme
    xidlehook
    xsel
    xtrt
    ymdl
  ];
}
