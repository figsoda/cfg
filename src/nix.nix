{ inputs }:

{
  buildMachines = [
    {
      hostName = "aarch64.nixos.community";
      maxJobs = 64;
      sshKey = "/root/.ssh/aarch64-build-box";
      sshUser = "figsoda";
      system = "aarch64-linux";
      supportedFeatures = [ "big-parallel" ];
    }
    {
      hostName = "darwin-build-box.winter.cafe";
      maxJobs = 16;
      sshKey = "/root/.ssh/darwin-build-box";
      sshUser = "figsoda";
      systems = [ "aarch64-darwin" "x86_64-darwin" ];
      supportedFeatures = [ "big-parallel" ];
    }
  ];
  distributedBuilds = true;
  gc = {
    automatic = true;
    dates = "04:30";
    options = "--delete-older-than 7d";
  };
  nixPath = [
    "nixos=${inputs.nixpkgs}"
    "nixpkgs=${inputs.nixpkgs}"
  ];
  registry.nixpkgs.flake = inputs.nixpkgs;
  settings = {
    auto-optimise-store = true;
    experimental-features = [ "flakes" "nix-command" "repl-flake" ];
    flake-registry = "${inputs.flake-registry}/flake-registry.json";
    keep-outputs = true;
    log-lines = 50;
    substituters = [
      "https://figsoda.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "figsoda.cachix.org-1:mJfTEL4qLCqymqynJlaTxxi5APlaM0DfWg+h+CRGa20="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
