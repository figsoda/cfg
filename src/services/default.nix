{
  auto-cpufreq.enable = true;

  earlyoom.enable = true;

  gnome = {
    at-spi2-core.enable = true;
    gnome-keyring.enable = true;
  };

  ratbagd.enable = true;

  pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
