{ pkgs }:

let
  inherit (pkgs)
    fish
    libsecret
    nixpkgs-review
    writers
    ;
in

writers.writeBashBin "nixpkgs-review" ''
  if [ "$1" = pr ]; then
    export GITHUB_TOKEN=$(${libsecret}/bin/secret-tool lookup github git)
    args=(--run ${fish}/bin/fish)
  elif [[ "$1" =~ rev|wip ]]; then
    args=(--no-shell)
  fi
  ${nixpkgs-review}/bin/nixpkgs-review "$@" "''${args[@]}"
''
