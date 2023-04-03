{ pkgs }:

let
  inherit (pkgs) fish nixpkgs-review writers;
in

writers.writeBashBin "nixpkgs-review" ''
  if [ "$1" = pr ]; then
    args=(--run ${fish}/bin/fish)
  elif [[ "$1" =~ rev|wip ]]; then
    args=(--no-shell)
  fi
  ${nixpkgs-review}/bin/nixpkgs-review "$@" "''${args[@]}"
''
