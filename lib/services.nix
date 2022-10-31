{ config, lib, pkgs, ... }: {
  services = {
    auto-cpufreq.enable = true;
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
    udev.extraRules = ''
      KERNEL=="rfkill", SUBSYSTEM=="misc", TAG+="uaccess"
    '';
    xserver = {
      enable = true;
      displayManager.sx.enable = true;
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
          accelSpeed = "0";
          middleEmulation = false;
        };
        touchpad = {
          accelProfile = "flat";
          accelSpeed = "0";
        };
      };
      windowManager.awesome = {
        enable = true;
        noArgb = true;
        package = pkgs.awesome.override { lua = pkgs.luajit; };
      };
      xkbOptions = "ctrl:nocaps";
    };
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
}
