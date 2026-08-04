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
      etc."jj/config.toml".source = writers.writeTOML "jj.toml" {
        user = {
          name = "figsoda";
          email = "figsoda@pm.me";
        };
      };
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
          proto = "virtiofs";
          socket = ".microvm/virtiofs.sock";
          source = ".";
          tag = "project";
        }
      ];
      socket = ".microvm/vm.sock";
      vcpu = 8;
      volumes = [
        {
          image = ".microvm/root.img";
          mountPoint = "/";
          size = 16384;
        }
      ];
      writableStoreOverlay = "/nix/.rw-store";
    };

    networking.hostName = name;

    fileSystems."/project/.microvm" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "mode=0000" ];
    };

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
        /.microvm
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
  mkdir -p .microvm
  ${getExe os.config.microvm.virtiofsd.package} \
    --shared-dir=. \
    --socket-path=.microvm/virtiofs.sock &

  while [ ! -S .microvm/virtiofs.sock ]; do
    sleep 0.25
  done

  ${getExe os.config.microvm.declaredRunner}
''
