{ config, pkgs, ... }:

with pkgs;

{
  environment.systemPackages = [
    (writers.writeDashBin "ghtok" ''
      ${libsecret}/bin/secret-tool lookup github git
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
      ${rofi}/bin/rofi -show todo -modes todo:${
        writers.writeBash "todo-mode" ''
          todos=~/.local/share/todos
          ${coreutils}/bin/mkdir -p ~/.local/share
          ${coreutils}/bin/touch "$todos"

          [ -z "$1" ] && ${coreutils}/bin/cat "$todos" && exit 0

          if [ "$1" = @ ]; then
            ${config.passthru.alacritty}/bin/alacritty -e ${config.programs.neovim.finalPackage}/bin/nvim "$todos"
          elif item=$(${ripgrep}/bin/rg '^\+\s*([^\s](.*[^\s])?)\s*$' -r '$1' <<< "$1"); then
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
    bat
    binutils
    blueberry
    bottom
    brightnessctl
    cargo-edit
    cargo-nextest
    cargo-play
    clang
    clipmenu
    delta
    (with eclipses; buildEclipse.override { jdk = openjdk17; } {
      inherit (eclipse-java) name src;
      inherit (eclipse-java.meta) description;
    })
    element-desktop
    fd
    firefox
    gcc
    gimp
    git-absorb
    hacksaw
    libreoffice-fresh
    libsecret
    mmtc
    mold
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
    nurl
    ouch
    pamixer
    pavucontrol
    psmisc
    python3
    qalculate-gtk
    qogir-icon-theme
    qogir-theme
    ripgrep
    rofi
    sagoin
    sccache
    sd
    shotgun
    spaceFM
    statix
    stylua
    tela-icon-theme
    xclip
    ymdl
  ];
}
