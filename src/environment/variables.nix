{ pkgs }:

let
  inherit (pkgs) writeText;
in

{
  BAT_STYLE = "numbers";
  BAT_THEME = "TwoDark";
  CC = "gcc";
  LESSHISTFILE = "-";
  PATH = "$HOME/.cargo/bin";
  RIPGREP_CONFIG_PATH = toString (writeText "rg-config" ''
    -S
    -g=!.git
    --hidden
  '');
  fish_features = "qmark-noglob";
}
