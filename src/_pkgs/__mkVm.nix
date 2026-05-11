{
  inputs,
  lib,
  pkgs,
  root,
}:

name: module:

let
  inherit (lib)
    getExe
    ;
  inherit (pkgs)
    stdenv
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
        just
        psmisc
        python3
        ripgrep
        root.pkgs.rust
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
      mem = 2047;
      shares = [
        {
          mountPoint = "/project";
          source = ".";
          tag = "project";
          securityModel = "mapped";
        }
      ];
      vcpu = 4;
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
        find /project '(' -name .git -o -name .jj ')' -prune -o -execdir chown figsoda:users {} ';'
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
