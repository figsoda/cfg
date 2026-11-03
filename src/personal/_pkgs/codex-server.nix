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
    socat
    writers
    ;
in

super.mkVm "codex-server" {
  environment.etc."codex/config.toml".source = writers.writeTOML "codex.toml" {
    approvals_reviewer = "auto_review";
  };

  microvm.qemu.extraArgs = [
    "-set"
    "netdev.qemu.hostfwd=unix:/proc/self/cwd/.microvm/codex.sock-:8000"
  ];

  networking.firewall.allowedTCPPorts = [ 8000 ];

  systemd.services.codex-server = {
    script = ''
      ${getExe codex} app-server --listen unix:///run/codex/server.sock &
      ${getExe socat} TCP-LISTEN:8000,fork,reuseaddr UNIX-CONNECT:/run/codex/server.sock &
      wait -n
    '';
    serviceConfig = {
      Group = "users";
      Restart = "always";
      RuntimeDirectory = "codex";
      User = "figsoda";
      WorkingDirectory = "/project";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
