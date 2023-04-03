{ config, pkgs }:

pkgs.writers.writeBashBin "r" ''
  if [ "$1" = cargo ] && nix eval --raw "nixpkgs#$1-$2" 2> /dev/null; then
    pkg=$1-$2
  else
    pkg=$1
  fi
  ${config.nix.package}/bin/nix run "nixpkgs#$pkg" -- "''${@:2}"
''
