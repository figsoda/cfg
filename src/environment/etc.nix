{
  config,
  lib,
  pkgs,
  root,
  super,
}:

let
  inherit (builtins) toJSON;
  inherit (lib)
    concatStrings
    generators
    imap0
    ;
  inherit (pkgs)
    concatText
    formats
    libsecret
    replaceVars
    swaynotificationcenter
    ;

  toml = (formats.toml { }).generate;

  gtkSettings = generators.toINI { } {
    Settings = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-name = "Qogir";
      gtk-enable-animations = false;
      gtk-font-name = "sans 8";
      gtk-icon-theme-name = "Tela-dark";
      gtk-theme-name = "adw-gtk3-dark";
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintfull";
      gtk-xft-rgba = "rgb";
    };
  };
in

{
  "niri/config.kdl".source = replaceVars ./niri.kdl {
    inherit (root.colors)
      black
      cyan
      darker
      lightgray
      yellow
      ;
  };

  "xdg/ghostty/config".text = with root.colors; ''
    adjust-cursor-thickness = 100%
    background = ${black}
    confirm-close-surface = false
    cursor-style = bar
    cursor-style-blink = false
    foreground = ${white}
    shell-integration-features = no-cursor
    window-padding-x = 4
    window-padding-y = 4
    ${concatStrings (
      imap0 (i: x: "palette = ${toString i}=${x}\n") [
        black
        red
        green
        yellow
        blue
        magenta
        cyan
        white
        black
        lightred
        green
        orange
        blue
        magenta
        cyan
        white
      ]
    )}
  '';

  "xdg/gtk-3.0/gtk.css".text = super.gtkCss "gtk3";
  "xdg/gtk-3.0/settings.ini".text = gtkSettings;
  "xdg/gtk-4.0/gtk.css".text = super.gtkCss "gtk4";
  "xdg/gtk-4.0/settings.ini".text = gtkSettings;

  "xdg/hypr/hypridle.conf".source = replaceVars ./hypridle.conf {
    hyprlock = config.programs.hyprlock.package;
    niri = config.programs.niri.package;
    systemd = config.systemd.package;
  };

  "xdg/hypr/hyprlock.conf".source = replaceVars ./hyprlock.conf {
    inherit (pkgs) coreutils;
    inherit (root.colors.nohash)
      black
      blue
      green
      lightgray
      lightred
      white
      ;
  };

  "xdg/nix-init/config.toml".source = toml "nix-init.toml" {
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
  "xdg/flat-dark.rasi".source = replaceVars ./flat-dark.rasi {
    inherit (root.colors)
      black
      blue
      cyan
      gray
      white
      ;
  };

  "xdg/sagoin/config.toml".source = toml "sagion.toml" {
    username = "${libsecret}/bin/secret-tool lookup umd username";
    username_type = "command";
    password = "${libsecret}/bin/secret-tool lookup umd password";
    password_type = "command";
  };

  "xdg/swaync/config.json".text = toJSON {
    control-center-layer = "overlay";
    positionY = "bottom";
    widgets = [
      "notifications"
      "mpris"
      "dnd"
    ];
  };
  "xdg/swaync/style.css".source = concatText "swaync.css" [
    "${swaynotificationcenter}/etc/xdg/swaync/style.css"
    (replaceVars ./swaync.css {
      inherit (root.colors)
        black
        darker
        dimgray
        gray
        lightgray
        white
        ;
    })
  ];

  "xdg/swayosd/config.toml".source = toml "swayosd.toml" {
    server.show_percentage = true;
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
