{ inputs }:

{
  channel.enable = false;
  registry.nixpkgs.flake = inputs.nixpkgs;
  settings = {
    auto-allocate-uids = true;
    auto-optimise-store = true;
    experimental-features = [
      "auto-allocate-uids"
      "ca-derivations"
      "cgroups"
      "dynamic-derivations"
      "flakes"
      "nix-command"
      "recursive-nix"
    ];
    extra-system-features = [
      "uid-range"
    ];
    flake-registry = "${inputs.flake-registry}/flake-registry.json";
    keep-outputs = true;
    log-lines = 50;
    nix-path = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
