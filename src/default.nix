{
  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  gtk.iconCache.enable = true;

  hardware.bluetooth.enable = true;

  security.sudo.wheelNeedsPassword = false;

  system = {
    autoUpgrade = {
      enable = true;
      dates = "04:00";
    };
    stateVersion = "22.05";
  };

  time.timeZone = "America/New_York";
}
