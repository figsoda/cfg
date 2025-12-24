{
  earlyoom.enable = true;

  gnome = {
    at-spi2-core.enable = true;
    gnome-keyring.enable = true;
  };

  pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  ratbagd.enable = true;
}
