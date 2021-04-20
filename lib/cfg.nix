{ config, lib, pkgs, ... }: {
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

  fonts = {
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace =
          [ "JetBrainsMono Nerd Font" "Cascadia Code" "Source Han Sans K" ];
        sansSerif = [ "Arimo Nerd Font" "Source Han Sans K" ];
        serif = [ "Arimo Nerd Font" "Source Han Sans K" ];
      };
      includeUserConf = false;
    };
    fonts = with pkgs; [
      cascadia-code
      (nerdfonts.override { fonts = [ "Arimo" "JetBrainsMono" ]; })
      noto-fonts-emoji
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
  };

  i18n = {
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = [ pkgs.fcitx5-rime ];
    };
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  networking = {
    firewall.enable = false;
    hostName = "nixos";
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

  programs = {
    command-not-found.enable = false;
    dconf.enable = true;
    ssh.askPassword = "${pkgs.writeShellScript "password-prompt" ''
      ${pkgs.yad}/bin/yad --title "Password prompt" \
        --fixed --on-top --center \
        --entry --hide-text
    ''}";
    steam.enable = true;
  };

  services = {
    auto-cpufreq.enable = true;
    blueman.enable = true;
    gnome3.at-spi2-core.enable = true;
    logind.lidSwitch = "ignore";
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      enableCtrlAltBackspace = true;
      inputClassSections = [''
        Identifier "pointer configuration"
        MatchIsPointer "true"
        Option "TransformationMatrix" "1 0 0 0 1 0 0 0 0.3"
      ''];
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
        };
        touchpad = {
          accelProfile = "flat";
          accelSpeed = "0";
          disableWhileTyping = true;
          tapping = false;
        };
      };
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';
      windowManager.awesome = {
        enable = true;
        noArgb = true;
      };
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "01:00";
    };
    stateVersion = "21.03";
  };

  systemd.services.nixos-upgrade = {
    script = lib.mkForce ''
      /run/wrappers/bin/sudo -u figsoda \
        ${config.nix.package}/bin/nix flake update --commit-lock-file
      ${pkgs.coreutils}/bin/cp flake.lock /etc/nixos
      ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch
    '';
    serviceConfig.WorkingDirectory = "/home/figsoda/dotfiles";
  };

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
