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
    gnome.at-spi2-core.enable = true;
    journald.extraConfig = ''
      SystemMaxUse=256M
    '';
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    ratbagd.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        job.execCmd = "";
        lightdm.enable = lib.mkForce false;
      };
      exportConfiguration = true;
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
        };
      };
      windowManager.awesome = {
        enable = true;
        noArgb = true;
        package = pkgs.awesome.override { luaPackages = pkgs.luajitPackages; };
      };
      xkbOptions = "ctrl:nocaps";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "01:00";
    };
    stateVersion = "21.05";
  };

  systemd = {
    services = {
      lockscreen = {
        wantedBy = [ "sleep.target" ];
        before = [ "sleep.target" ];
        environment = {
          DISPLAY = ":1";
          XAUTHORITY = "/home/figsoda/.local/share/sx/xauthority";
        };
        serviceConfig = {
          Type = "forking";
          User = "figsoda";
          ExecStart = "${config.passthru.lockscreen}/bin/lockscreen";
        };
      };
      nixos-upgrade = {
        serviceConfig.WorkingDirectory = "/home/figsoda/dotfiles";
        script = lib.mkForce ''
          ${pkgs.coreutils}/bin/sleep 5
          /run/wrappers/bin/sudo -u figsoda \
            ${config.nix.package}/bin/nix flake update --commit-lock-file
          ${pkgs.coreutils}/bin/cp flake.lock /etc/nixos
          ${config.system.build.nixos-rebuild}/bin/nixos-rebuild switch
        '';
      };
    };
    timers = {
      nix-gc.timerConfig.WakeSystem = true;
      nixos-upgrade.timerConfig.WakeSystem = true;
    };
  };

  time.timeZone = "America/New_York";

  users.users.figsoda = {
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    isNormalUser = true;
    shell = "${pkgs.fish}/bin/fish";
  };
}
