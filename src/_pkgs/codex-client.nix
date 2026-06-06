{ lib, pkgs }:

let
  inherit (lib)
    getExe
    ;
  inherit (pkgs)
    codex
    path
    writers
    ;
in

writers.writeDashBin "codex-client" ''
  CODEX_TOKEN=${toString path} ${getExe codex} --remote ws://127.0.0.1:8000 \
    --remote-auth-token-env CODEX_TOKEN -s workspace-write -a never
''
