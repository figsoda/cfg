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
      };
    }
  ];
}
