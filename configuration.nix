{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      (vscodium.overrideAttrs (oldAttrs: {
        buildInputs = vscodium.buildInputs ++ [ jq moreutils ];
        installPhase = ''
          jq -e 'setpath(["extensionsGallery"]; {
            "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
            "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
            "itemUrl": "https://marketplace.visualstudio.com/items"
          })' resources/app/product.json | sponge resources/app/product.json
        '' + vscodium.installPhase;
      }))
      alacritty
      bat
      bottom
      celluloid
      clipmenu
      exa
      fd
      firefox
      fish
      flameshot
      gcc
      gimp
      git
      hyperfine
      i3lock-color
      imagemagick
      just
      micro
      mpc_cli
      networkmanagerapplet
      pamixer
      pavucontrol
      psmisc
      qalculate-gtk
      qogir-icon-theme
      qogir-theme
      ripgrep
      rofi
      rofi-calc
      rofi-emoji
      rustup
      sd
      starship
      sxiv
      udiskie
      unzip
      volctl
      xfce.thunar
      xsel
      xss-lock
      xz
      zip
    ];
    variables = {
      EDITOR = "micro";
      PATH = "$HOME/.cargo/bin";
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font " ];
        sansSerif = [ "Arimo Nerd Font" ];
        serif = [ "Arimo Nerd Font" ];
      };
      includeUserConf = false;
    };
    fonts = with pkgs; [
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "Arimo" "JetBrainsMono" ]; })
    ];
  };

  gtk.iconCache.enable = true;

  hardware = {
    acpilight.enable = true;
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
  };

  networking = {
    firewall.enable = false;
    hostName = "nixos";
    interfaces.enp1s0.useDHCP = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager = {
      enable = true;
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
    };
    useDHCP = false;
  };

  # nixpkgs.config.allowUnfree = true;

  services = {
    blueman.enable = true;
    gnome3 = {
      at-spi2-core.enable = true;
      gnome-keyring.enable = true;
    };
    mpd = {
      enable = true;
      musicDirectory = "/home/figsoda/music";
      user = "figsoda";
      extraConfig = ''
        restore_paused "yes"
        audio_output {
          type "pulse"
          name "Music player daemon"
        }
      '';
    };
    printing.enable = true;
    unclutter-xfixes.enable = true;
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      libinput = {
        enable = true;
        accelProfile = "flat";
        tapping = false;
      };
      windowManager.awesome = {
        enable = true;
        noArgb = true;
      };
    };
  };

  system = {
    autoUpgrade.enable = true;
    stateVersion = "21.03";
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "video" "networkmanager" "wheel" ];
    isNormalUser = true;
    shell = "/run/current-system/sw/bin/fish";
  };
}
