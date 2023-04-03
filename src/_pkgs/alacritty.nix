{ pkgs }:

let
  inherit (pkgs) alacritty writers;
in

writers.writeDashBin "alacritty" ''
  ${alacritty}/bin/alacritty msg create-window "$@" || {
    [ $? = 1 ] && ${alacritty}/bin/alacritty "$@"
  }
''
