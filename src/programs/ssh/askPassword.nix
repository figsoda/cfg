{ pkgs }:

let
  inherit (pkgs) writers yad;
in

toString (
  writers.writeDash "password-prompt" ''
    ${yad}/bin/yad --title "Password prompt" \
      --fixed --on-top --center \
      --entry --hide-text
  ''
)
