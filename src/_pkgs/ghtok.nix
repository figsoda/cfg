{ pkgs }:

pkgs.writers.writeDashBin "ghtok" ''
  ${pkgs.libsecret}/bin/secret-tool lookup github git
''
