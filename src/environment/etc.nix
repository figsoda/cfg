{ lib, pkgs, root }:

let
  inherit (lib) generators;
  inherit (pkgs) fish formats libsecret substituteAll;

  gtkSettings = generators.toINI { } {
    Settings = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = "Qogir";
      gtk-enable-animations = false;
      gtk-font-name = "sans 18";
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
  "xdg/alacritty/alacritty.yml".text = generators.toYAML { } {
    colors = with root.colors; {
      primary = {
        foreground = white;
        background = black;
      };

      cursor = {
        text = lightgray;
        cursor = white;
      };

      normal = {
        inherit black blue cyan green magenta red white yellow;
      };

      bright = {
        inherit black blue cyan green magenta white;
        red = lightred;
        yellow = orange;
      };
    };

    cursor.style = "Beam";
    font.size = 8;
    shell.program = "${fish}/bin/fish";
    window.padding = {
      x = 4;
      y = 4;
    };
  };

  "xdg/gtk-3.0/settings.ini".text = gtkSettings;
  "xdg/gtk-4.0/settings.ini".text = gtkSettings;

  "xdg/nix-init/config.toml".source = (formats.toml { }).generate "config.toml" {
    maintainers = [ "figsoda" ];
    access-tokens = {
      "github.com".command = [
        "${libsecret}/bin/secret-tool"
        "lookup"
        "github"
        "git"
      ];
    };
  };

  "xdg/rofi.rasi".source = ./rofi.rasi;
  "xdg/flat-dark.rasi".source = substituteAll (root.colors // {
    src = ./flat-dark.rasi;
  });

  "xdg/sagoin/config.toml".source = (formats.toml { }).generate "config.toml" {
    username = "${libsecret}/bin/secret-tool lookup umd username";
    username_type = "command";
    password = "${libsecret}/bin/secret-tool lookup umd password";
    password_type = "command";
  };

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
}
