{
  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  gtk.iconCache.enable = true;

  hardware = {
    bluetooth.enable = true;
    nvidia.prime = {
      amdgpuBusId = "PCI:194:0:0";
      nvidiaBusId = "PCI:193:0:0";
    };
  };

  security = {
    soteria.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "04:00";
    };
    stateVersion = "22.05";
  };

  time.timeZone = "America/New_York";
}
