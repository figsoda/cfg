{ config, lib, pkgs, ... }: {
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
  };

  environment = {
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=/dev/null
      DOCUMENTS=files
      DOWNLOAD=files
      MUSIC=music
      PICTURES=files
      PUBLICSHARE=/dev/null
      TEMPLATES=/dev/null
      VIDEOS=files
    '';
    variables = {
      LESSHISTFILE = "-";
      PATH = "$HOME/.cargo/bin";
      RIPGREP_CONFIG_PATH = "${pkgs.writeText "rg-config" ''
        -S
        -g=!.git
        --hidden
      ''}";
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace =
          [ "JetBrainsMono Nerd Font" "Cascadia Code" "Sarasa Mono SC" ];
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

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

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
      wifi = {
        backend = "iwd";
        macAddress = "random";
      };
    };
    useDHCP = false;
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "04:00";
    };
    stateVersion = "21.05";
  };

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
  };

  xdg.mime.defaultApplications = {
    "application/pdf" = "firefox.desktop";
    "image/bmp" = "sxiv.desktop";
    "image/gif" = "sxiv.desktop";
    "image/jpeg" = "sxiv.desktop";
    "image/jpg" = "sxiv.desktop";
    "image/png" = "sxiv.desktop";
    "image/tiff" = "sxiv.desktop";
    "image/x-bmp" = "sxiv.desktop";
    "image/x-portable-anymap" = "sxiv.desktop";
    "image/x-portable-bitmap" = "sxiv.desktop";
    "image/x-portable-graymap" = "sxiv.desktop";
    "image/x-tga" = "sxiv.desktop";
    "image/x-xpixmap" = "sxiv.desktop";
    "inode/directory" = "spacefm.desktop";
  };
}
