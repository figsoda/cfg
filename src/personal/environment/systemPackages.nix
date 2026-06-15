{ pkgs, root }:

with pkgs;

builtins.attrValues root.pkgs
++ [
  heroic
  libsecret
]
