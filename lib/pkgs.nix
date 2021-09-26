{ config, pkgs, ... }:

with pkgs;

rec {
  environment.systemPackages = builtins.attrValues passthru ++ [
    (writeShellScriptBin "ghtok" ''
      ${libressl}/bin/openssl aes-256-cbc -d -in ~/.config/secrets/github
    '')
    (writeShellScriptBin "r" ''
      ${config.nix.package}/bin/nix run "nixpkgs#$1" -- "''${@:2}"
    '')
    (writeShellScriptBin "rofi-todo" ''
      ${rofi}/bin/rofi -show todo -modi todo:${
        writeShellScript "todo-modi" ''
          todos=~/.local/share/todos
          ${coreutils}/bin/mkdir -p ~/.local/share
          ${coreutils}/bin/touch "$todos"

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
    delta
    fd
    firefox
    gcc
    gimp
    hacksaw
    libreoffice-fresh
    libressl
    llvmPackages_latest.lld
    mmtc
    mpc_cli
    (mpv.override {
      scripts = with mpvScripts; [ autoload sponsorblock thumbnail ];
    })
    newsflash
    nix-update
    nixpkgs-fmt
    nixpkgs-hammering
    nixpkgs-review
    pamixer
    pavucontrol
    psmisc
    python3
    qalculate-gtk
    qogir-icon-theme
    qogir-theme
    ripgrep
    (rofi.override { plugins = [ rofi-calc ]; })
    sd
    shotgun
    spaceFM
    stylua
    sxiv
    tela-icon-theme
    xclip
    xtrt
    ymdl
  ];

  passthru = {
    element-desktop = (element-desktop.override {
      element-web = element-web.override { conf.showLabSettings = true; };
    });
    lockscreen = writeShellScriptBin "lockscreen" ''
      ${i3lock-color}/bin/i3lock-color \
        -i ~/.config/wallpaper.png -k \
        --{inside{ver,wrong,},ring,line,separator}-color=00000000 \
        --ringver-color=98c379 --ringwrong-color=f83c40 \
        --keyhl-color=61afef --bshl-color=d19a66 \
        --verif-color=98c379 --wrong-color=f83c40 \
        --ind-pos=x+w/7:y+h-w/8 \
        --{time,date}-font=monospace \
        --{layout,verif,wrong,greeter}-size=32 \
        --time-color=61afef --time-size=36 \
        --date-pos=ix:iy+36 --date-color=98c379 --date-str=%F --date-size=28 \
        --verif-text=Verifying... \
        --wrong-text="Try again!" \
        --noinput-text="No input" \
        --lock-text=Locking... --lockfailed-text="Lock failed!" \
        --radius 108 --ring-width 8
    '';
    rust = fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ];
  };
}
