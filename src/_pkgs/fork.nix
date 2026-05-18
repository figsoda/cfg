{ pkgs }:

let
  inherit (pkgs)
    writers
    ;
in

writers.writeDashBin "fork" ''
  set -eu

  root=$(jj root)
  name=$(basename "$root")
  out="$HOME/$name-$1"

  origin=$(git remote get-url origin)
  upstream=$(git remote get-url upstream 2>/dev/null || true)

  jj git clone . "$out" --depth 1 --fetch-tags none
  jj git remote add "$1" "$out"
  jj -R "$out" git remote set-url origin "$origin"
  if [ -n "$upstream" ]; then
    jj -R "$out" git remote add upstream "$upstream"
  fi
''
