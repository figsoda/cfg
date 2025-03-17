{ config, inputs, pkgs, root }:

let
  nix-index = inputs.nix-index-database.packages.${config.nixpkgs.system}.default;
in

with pkgs;

builtins.attrValues root.pkgs ++ [
  bat
  binutils
  blueberry
  bottom
  brightnessctl
  bubblewrap
  cargo-edit
  cargo-insta
  cargo-nextest
  clang
  clipmenu
  dafny
  delta
  dune_3
  element-desktop
  erdtree
  fd
  firefox-bin # https://github.com/NixOS/nixpkgs/issues/332540
  fishPlugins.async-prompt
  fishPlugins.autopair
  gcc
  git-absorb
  gnumake
  gradescope-submit
  haskell-language-server
  libreoffice-fresh
  libsecret
  lutris
  mmtc
  mold
  mpc_cli
  namaka
  nasm
  nix-index
  nix-init
  nix-melt
  nix-update
  nixpkgs-fmt
  nixpkgs-hammering
  nsxiv
  nurl
  ocaml
  ocamlPackages.utop
  ocamlformat
  ouch
  psmisc
  pwvucontrol
  python3
  qalculate-gtk
  qogir-icon-theme
  qogir-theme
  racket
  ripgrep
  rofi
  sagoin
  sccache
  sd
  shotgun
  slop
  spaceFM
  sshfs
  stack
  statix
  stylua
  tela-icon-theme
  xclip
  ymdl
  zig
]
