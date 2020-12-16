{ lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        efiSupport = true;
      };
    };
  };

  environment = {
    etc."resolv.conf".text = ''
      nameserver 1.1.1.1
      nameserver 1.0.0.1
    '';
    systemPackages = with pkgs; [
      (writeTextFile {
        name = "default-icon-theme";
        destination = "/share/icons/default/index.theme";
        text = ''
          [icon theme]
          Inherits=Qogir
        '';
      })
      alacritty
      bat
      bottom
      cargo-edit
      celluloid
      clipmenu
      exa
      fd
      firefox
      gcc
      gimp
      git
      i3lock-color
      just
      libreoffice-fresh
      luaformatter
      maim
      micro
      mmtc
      mpc_cli
      mpd
      networkmanagerapplet
      nixfmt
      pamixer
      papirus-icon-theme
      pavucontrol
      psmisc
      python3
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
      unclutter-xfixes
      volctl
      (vscode-with-extensions.override {
        vscode = vscodium.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ jq moreutils ];
          installPhase = ''
            jq -e 'setpath(["extensionsGallery"]; {
              "serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
              "cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
              "itemUrl": "https://marketplace.visualstudio.com/items"
            })' resources/app/product.json | sponge resources/app/product.json
          '' + old.installPhase;
        });
        vscodeExtensions = with vscode-extensions; [
          (vscode-utils.extensionFromVscodeMarketplace {
            name = "color-highlight";
            publisher = "naumovs";
            version = "2.3.0";
            sha256 = "1syzf43ws343z911fnhrlbzbx70gdn930q67yqkf6g0mj8lf2za2";
          })
          a5huynh.vscode-ron
          bbenoist.Nix
          matklad.rust-analyzer
          mskelton.one-dark-theme
          pkief.material-icon-theme
          redhat.vscode-yaml
          serayuzgur.crates
          skyapps.fish-vscode
          tamasfe.even-better-toml
        ];
      })
      xfce.thunar
      xsel
      xss-lock
      xtrt
    ];
    variables = {
      EDITOR = "micro";
      LESSHISTFILE = "-";
      PATH = "$HOME/.cargo/bin";
    };
  };

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Cascadia Mono" ];
        sansSerif = [ "Arimo Nerd Font" ];
        serif = [ "Arimo Nerd Font" ];
      };
      includeUserConf = false;
    };
    fonts = with pkgs; [
      cascadia-code
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "Arimo" "JetBrainsMono" ]; })
      source-han-sans
    ];
  };

  gtk.iconCache.enable = true;

  hardware = {
    acpilight.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    pulseaudio.enable = true;
  };

  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  networking = {
    firewall.enable = false;
    hostName = "nixos";
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
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

  nix = {
    autoOptimiseStore = true;
    gc = {
      automatic = true;
      dates = "Fri, 03:00";
      options = "--delete-older-than 3d";
    };
    package = pkgs.nixUnstable;
  };

  nixpkgs = {
    config.allowUnfreePredicate = pkg: lib.hasPrefix "steam" (lib.getName pkg);
    overlays = [
      (import (fetchTarball
        "https://github.com/figsoda/nix-packages/archive/main.tar.gz"))
    ];
  };

  programs = {
    fish.enable = true;
    ssh.askPassword = "";
    steam.enable = true;
  };

  services = {
    blueman.enable = true;
    gnome3.at-spi2-core.enable = true;
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      inputClassSections = [''
        Identifier "pointer configuration"
        MatchIsPointer "true"
        Option "TransformationMatrix" "1 0 0 0 1 0 0 0 0.3"
      ''];
      libinput = {
        enable = true;
        accelProfile = "flat";
        accelSpeed = "0";
        tapping = false;
      };
      windowManager.awesome = {
        enable = true;
        noArgb = true;
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "03:30";
    };
    stateVersion = "21.03";
  };

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
