{
  enable = true;
  profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-animations = false;
          icon-theme = "Tela-dark";
        };
        "org/gnome/desktop/wm/preferences".button-layout = "";
      };
    }
  ];
}
