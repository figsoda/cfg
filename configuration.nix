{ pkgs, ... }:

let user = "figsoda";
in {
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
      (rofi.override { plugins = [ rofi-calc rofi-emoji ]; })
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
    pulseaudio.enable = true;
  };

  networking = {
    firewall.enable = false;
    hostName = "nixos";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager = {
      enable = true;
      ethernet.macAddress = "random";
      wifi.macAddress = "random";
    };
    useDHCP = false;
  };

  # nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  services = {
    blueman.enable = true;
    gnome3 = {
      at-spi2-core.enable = true;
      gnome-keyring.enable = true;
    };
    mpd = {
      inherit user;
      enable = true;
      musicDirectory = "/home/${user}/music";
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

  users.users."${user}" = {
    extraGroups = [ "audio" "video" "networkmanager" "wheel" ];
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
