{
  lib,
  pkgs,
  super,
}:

let
  inherit (lib)
    getExe
    ;
  inherit (pkgs)
    codex
    ;
in

super.mkVm "codex-server" {
  microvm.forwardPorts = [
    {
      from = "host";
      guest.port = 8000;
      host = {
        address = "127.0.0.1";
        port = 8000;
      };
    }
  ];

  networking.firewall.allowedTCPPorts = [ 8000 ];

  systemd.services.codex-server = {
    script = ''
      ${getExe codex} app-server --listen ws://0.0.0.0:8000
    '';
    serviceConfig = {
      Group = "users";
      Restart = "always";
      User = "figsoda";
      WorkingDirectory = "/project";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
