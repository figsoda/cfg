{ config, pkgs, ... }:

with pkgs;

rec {
  environment.systemPackages = builtins.attrValues passthru ++ [
    (writers.writeDashBin "ghtok" ''
      ${pkgs.libsecret}/bin/secret-tool lookup github git
    '')
    (writers.writeBashBin "r" ''
      if [ "$1" = cargo ] && nix eval --raw "nixpkgs#$1-$2" 2> /dev/null; then
        pkg=$1-$2
      else
        pkg=$1
      fi
      ${config.nix.package}/bin/nix run "nixpkgs#$pkg" -- "''${@:2}"
    '')
    (writers.writeBashBin "rofi-todo" ''
      ${rofi}/bin/rofi -show todo -modi todo:${
        writers.writeBash "todo-modi" ''
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
    (writers.writeDashBin "alacritty" ''
      ${alacritty}/bin/alacritty msg create-window "$@" || {
        [ $? = 1 ] && ${alacritty}/bin/alacritty "$@"
      }
    '')
    bat
    binutils
    blueberry
    bottom
    brightnessctl
    cargo-edit
    cargo-play
    clipmenu
    delta
    (with eclipses; buildEclipseUnversioned.override { jdk = openjdk17; } {
      inherit (eclipse-java) name src;
      inherit (eclipse-java.meta) description;
      productVersion = lib.getVersion eclipse-java;
    })
    element-desktop
    fd
    firefox
    gcc
    gimp
    hacksaw
    libreoffice-fresh
    libsecret
    llvmPackages_latest.lld
    mmtc
    mpc_cli
    (mpv.override {
      scripts = with mpvScripts; [ autoload sponsorblock thumbnail ];
    })
    nix-update
    nixpkgs-fmt
    nixpkgs-hammering
    (writers.writeBashBin "nixpkgs-review" ''
      if [ "$1" = pr ]; then
        args=(--run ${fish}/bin/fish)
      elif [[ "$1" =~ rev|wip ]]; then
        args=(--no-shell)
      fi
      ${nixpkgs-review}/bin/nixpkgs-review "$@" "''${args[@]}"
    '')
    nsxiv
    pamixer
    pavucontrol
    psmisc
    python3
    qalculate-gtk
    qogir-icon-theme
    qogir-theme
    ripgrep
    rofi
    sd
    shotgun
    spaceFM
    stylua
    tela-icon-theme
    umd-cs-submit
    xclip
    xtrt
    ymdl
  ];

  passthru = {
    lockscreen = with import ./colors.nix; writers.writeBashBin "lockscreen" ''
      ${i3lock-color}/bin/i3lock-color \
        -i ~/.config/wallpaper.png -k \
        --{inside{ver,wrong,},ring,line,separator}-color=00000000 \
        --ringver-color=${green} --ringwrong-color=${lightred} \
        --keyhl-color=${blue} --bshl-color=${orange} \
        --verif-color=${green} --wrong-color=${lightred} \
        --ind-pos=x+w/7:y+h-w/8 \
        --{time,date}-font=monospace \
        --{layout,verif,wrong,greeter}-size=32 \
        --time-color=${blue} --time-size=36 \
        --date-pos=ix:iy+36 --date-color=${green} --date-str=%F --date-size=28 \
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
