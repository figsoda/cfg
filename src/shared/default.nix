{
  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  gtk.iconCache.enable = true;

  hardware.bluetooth.enable = true;

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  nixpkgs.config.allowUnfree = true;

  security = {
    soteria.enable = true;
  };

  system.stateVersion = "22.05";

  time.timeZone = "America/New_York";
}
