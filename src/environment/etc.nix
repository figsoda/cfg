{ lib, pkgs, root }:

let
  inherit (lib) concatStrings generators mapAttrsToList;
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
  "xdg/alacritty/alacritty.toml".source = (formats.toml { }).generate "alacritty.toml" {
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

  "xdg/gtk-4.0/gtk.css".text = concatStrings (mapAttrsToList (k: v: "@define-color ${k} ${v};\n") (with root.colors; {
    accent_bg_color = blue;
    accent_color = blue;
    accent_fg_color = black;
    card_bg_color = black;
    card_fg_color = white;
    destructive_bg_color = red;
    destructive_color = red;
    destructive_fg_color = black;
    dialog_bg_color = black;
    dialog_fg_color = white;
    error_bg_color = red;
    error_color = red;
    error_fg_color = black;
    headerbar_backdrop_color = black;
    headerbar_bg_color = black;
    headerbar_border_color = black;
    headerbar_darker_shade_color = black;
    headerbar_fg_color = white;
    headerbar_shade_color = black;
    popover_bg_color = black;
    popover_fg_color = white;
    popover_shade_color = white;
    scrollbar_outline_color = black;
    secondary_sidebar_backdrop_color = black;
    secondary_sidebar_bg_color = black;
    secondary_sidebar_fg_color = white;
    secondary_sidebar_shade_color = black;
    shade_color = black;
    sidebar_backdrop_color = black;
    sidebar_bg_color = black;
    sidebar_fg_color = white;
    sidebar_shade_color = black;
    success_bg_color = green;
    success_color = green;
    success_fg_color = black;
    thumbnail_bg_color = black;
    thumbnail_fg_color = white;
    view_bg_color = black;
    view_fg_color = white;
    warning_bg_color = yellow;
    warning_color = yellow;
    warning_fg_color = black;
    window_bg_color = black;
    window_fg_color = white;
  }));

  "xdg/gtk-4.0/settings.ini".text = gtkSettings;

  "xdg/nix-init/config.toml".source = (formats.toml { }).generate "config.toml" {
    access-tokens = {
      "github.com".command = [
        "${libsecret}/bin/secret-tool"
        "lookup"
        "github"
        "git"
      ];
    };
    commit = true;
    maintainers = [ "figsoda" ];
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
