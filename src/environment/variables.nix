{ pkgs }:

let
  inherit (pkgs) writeText;
in

{
  BAT_STYLE = "numbers";
  BAT_THEME = "TwoDark";
  CC = "gcc";
  ERDTREE_CONFIG_PATH = writeText "erd-config" ''
    --dir-order first
    --human
    --icons
    --sort name
  '';
  LESSHISTFILE = "-";
  PATH = "$HOME/.cargo/bin";
  RIPGREP_CONFIG_PATH = writeText "rg-config" ''
    -S
    -g=!.git
    --hidden
  '';
  STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
  fish_features = "qmark-noglob";
}
