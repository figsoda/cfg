{ pkgs, root }:

let
  inherit (pkgs) formats replaceVars writeText;
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
  IRONBAR_CONFIG = (formats.toml { }).generate "ironbar.toml" {
    height = 0;
    popup_autohide = true;
    popup_gap = 0;
    position = "top";
    start = [
      {
        type = "workspaces";
        hidden = [ "7" ];
        sort = "added";
      }
      {
        type = "focused";
        icon_size = 16;
        truncate = {
          max_length = 80;
          mode = "end";
        };
      }
    ];
    end = [
      {
        type = "music";
        format = "{title} - {artist}";
        player_type = "mpd";
        truncate = {
          max_length = 32;
          mode = "end";
        };
      }
      {
        type = "tray";
        icon_size = 16;
      }
      {
        type = "battery";
        icon_size = 12;
      }
      {
        type = "clock";
        format = "%F %T";
      }
      { type = "notifications"; }
    ];
  };
  IRONBAR_CSS = pkgs.linkFarm "ironbar-css" [
    {
      name = "style.css";
      path = replaceVars ./ironbar.css {
        inherit (root.colors)
          black
          blue
          darker
          white
          yellow
          ;
      };
    }
  ];

  LESSHISTFILE = "-";
  PATH = "$HOME/.cargo/bin";
  RIPGREP_CONFIG_PATH = writeText "rg-config" ''
    -S
    -g=!.git
    --hidden
  '';
  fish_features = "qmark-noglob";
}
