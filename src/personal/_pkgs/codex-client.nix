{ lib, pkgs }:

let
  inherit (lib)
    getExe
    ;
  inherit (pkgs)
    codex
    writers
    ;
in

writers.writeDashBin "codex-client" ''
  exec ${getExe codex} --remote "unix://$PWD/.microvm/codex.sock"
''
