{ lib, pkgs }:

let
  inherit (lib)
    getExe
    ;
  inherit (pkgs)
    codex
    util-linux
    writers
    ;
in

writers.writeDashBin "codex-client" ''
  set -euo pipefail

  pid=$(cat .microvm/qemu.pid)
  port=$(
    ${util-linux}/bin/lsfd --pid "$pid" --noheadings \
      --filter 'type == "TCP" and sock.listening' \
      --output tcp.lport
  )

  CODEX_EXEC_SERVER_URL="ws://127.0.0.1:$port" \
    exec ${getExe codex} --no-daemon --cd /project \
    -c approvals_reviewer=auto_review \
    -c sandbox_mode=danger-full-access
''
