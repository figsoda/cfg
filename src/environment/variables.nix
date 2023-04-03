{ pkgs }:

let
  inherit (pkgs) formats libsecret writeText;
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
  SAGOIN_CONFIG = toString ((formats.toml { }).generate "sagoin.toml" {
    username = "${libsecret}/bin/secret-tool lookup umd username";
    username_type = "command";
    password = "${libsecret}/bin/secret-tool lookup umd password";
    password_type = "command";
  });
  fish_features = "qmark-noglob";
}
