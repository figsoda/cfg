{ lib, pkgs, ... }:

let
  gtkSettings = lib.generators.toINI { } {
    Settings = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = "Qogir";
      gtk-enable-animations = false;
      gtk-font-name = "sans 14";
      gtk-icon-theme-name = "Tela-dark";
      gtk-theme-name = "Qogir-Dark";
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
    };
  };
in

{
  environment.etc = {
    "xdg/alacritty/alacritty.yml".text = lib.generators.toYAML { } {
      colors = with import ./colors.nix; {
        primary = {
          foreground = white;
          background = black;
        };

        cursor = {
          text = dimwhite;
          cursor = white;
        };

        normal = {
          inherit black blue cyan green magenta red white yellow;
        };

        bright = {
          inherit black blue cyan green magenta white;
          red = darkred;
          yellow = orange;
        };
      };

      cursor.style = "Beam";
      font.size = 8;
      shell.program = "${pkgs.fish}/bin/fish";
      window.padding = {
        x = 4;
        y = 4;
      };
    };

    "xdg/gtk-3.0/settings.ini".text = gtkSettings;
    "xdg/gtk-4.0/settings.ini".text = gtkSettings;

    "xdg/rofi.rasi".source = ./rofi/rofi.rasi;
    "xdg/flat-dark.rasi".source = ./rofi/flat-dark.rasi;

    "xdg/user-dirs.defaults".text = ''
      DESKTOP=/dev/null
      DOCUMENTS=files
      DOWNLOAD=files
      MUSIC=music
      PICTURES=files
      PUBLICSHARE=/dev/null
      TEMPLATES=/dev/null
      VIDEOS=files
    '';
  };
}
