{ lib, pkgs, ... }: {
  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };

  console.useXkbConfig = true;

  documentation = {
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  environment.variables = {
    BAT_STYLE = "numbers";
    BAT_THEME = "TwoDark";
    CC = "gcc";
    LESSHISTFILE = "-";
    PATH = "$HOME/.cargo/bin";
    RIPGREP_CONFIG_PATH = "${pkgs.writeText "rg-config" ''
      -S
      -g=!.git
      --hidden
    ''}";
    SAGOIN_CONFIG = "${(pkgs.formats.toml { }).generate "sagoin.toml" {
      username = "${pkgs.libsecret}/bin/secret-tool lookup umd username";
      username_type = "command";
      password = "${pkgs.libsecret}/bin/secret-tool lookup umd password";
      password_type = "command";
    }}";
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Cascadia Code" "Sarasa Mono SC" ];
        sansSerif = [ "Arimo Nerd Font" "Sarasa Gothic SC" ];
        serif = [ "Arimo Nerd Font" "Sarasa Gothic SC" ];
      };
      includeUserConf = false;
    };
    fonts = with pkgs; [
      cascadia-code
      (nerdfonts.override { fonts = [ "Arimo" "JetBrainsMono" ]; })
      noto-fonts-emoji
      sarasa-gothic
    ];
  };

  gtk.iconCache.enable = true;

  hardware.bluetooth.enable = true;

  i18n = {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [ pkgs.fcitx5-rime ];
    };
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  networking = {
    nameservers = [ "9.9.9.9" "149.112.112.122" ];
    networkmanager = {
      enable = true;
      dns = "none";
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
    };
    useDHCP = false;
  };

  security.sudo.wheelNeedsPassword = false;

  system = {
    autoUpgrade = {
      enable = true;
      dates = "04:00";
    };
    stateVersion = "22.05";
  };

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "image/avif" = "nsxiv.desktop";
    "image/bmp" = "nsxiv.desktop";
    "image/gif" = "nsxiv.desktop";
    "image/heic" = "nsxiv.desktop";
    "image/heif" = "nsxiv.desktop";
    "image/jp2" = "nsxiv.desktop";
    "image/jpeg" = "nsxiv.desktop";
    "image/jpg" = "nsxiv.desktop";
    "image/jxl" = "nsxiv.desktop";
    "image/png" = "nsxiv.desktop";
    "image/svg+xml" = "nsxiv.desktop";
    "image/tiff" = "nsxiv.desktop";
    "image/webp" = "nsxiv.desktop";
    "image/x-bmp" = "nsxiv.desktop";
    "image/x-portable-anymap" = "nsxiv.desktop";
    "image/x-portable-bitmap" = "nsxiv.desktop";
    "image/x-portable-graymap" = "nsxiv.desktop";
    "image/x-tga" = "nsxiv.desktop";
    "image/x-xpixmap" = "nsxiv.desktop";
    "inode/directory" = "spacefm.desktop";
  };
}
