{
  config,
  inputs,
  lib,
  pkgs,
}:

name: module:

let
  inherit (lib)
    getExe
    ;
  inherit (config.passthru)
    rust
    ;
  inherit (pkgs)
    stdenv
    writeText
    writers
    ;

  baseModule = {
    environment = {
      interactiveShellInit = /* bash */ ''
        cd /project
      '';
      systemPackages = with pkgs; [
        binutils
        cargo-insta
        cargo-nextest
        clang
        fd
        gcc
        gnumake
        jq
        jujutsu
        just
        psmisc
        python3
        ripgrep
        rust
        unnix
        zig
      ];
      variables.JJ_CONFIG = writers.writeTOML "jj.toml" {
        user = {
          name = "figsoda";
          email = "figsoda@pm.me";
        };
      };
    };

    microvm = {
      hypervisor = "qemu";
      interfaces = [
        {
          id = "qemu";
          type = "user";
          mac = "00:00:00:00:00:00";
        }
      ];
      mem = 8192;
      shares = [
        {
          mountPoint = "/project";
          source = ".";
          tag = "project";
          securityModel = "mapped";
        }
      ];
      vcpu = 8;
      volumes = [
        {
          image = "root.img";
          mountPoint = "/";
          size = 16384;
        }
      ];
      writableStoreOverlay = "/nix/.rw-store";
    };

    networking.hostName = name;

    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        substituters = [
          "https://fenix.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    programs.git = {
      enable = true;
      config.core.excludesFile = writeText ".gitignore" ''
        /root.img
      '';
    };

    security.sudo.extraRules = [
      {
        users = [ "figsoda" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/poweroff";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    services.getty.autologinUser = "figsoda";

    system.stateVersion = "26.05";

    systemd.services.chown = {
      script = ''
        find /project ! -path /project/root.img -exec chown figsoda:users {} ';' || true
      '';
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];
    };

    users.users.figsoda.isNormalUser = true;
  };

  os = lib.nixosSystem {
    inherit (stdenv.hostPlatform) system;
    modules = [
      baseModule
      inputs.microvm.nixosModules.microvm
      module
    ];
  };
in

writers.writeDashBin name ''
  exec ${getExe os.config.microvm.declaredRunner}
''
