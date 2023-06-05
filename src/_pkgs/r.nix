{ config, pkgs }:

pkgs.writers.writeBashBin "r" ''
  if [ "$1" = cargo ] && nix eval --raw "nixpkgs#$1-$2" 2> /dev/null; then
    ${config.nix.package}/bin/nix shell "nixpkgs#$1-$2" -c cargo "''${@:2}"
  else
    ${config.nix.package}/bin/nix run "nixpkgs#$1" -- "''${@:2}"
  fi
''
