{ inputs }:

{
  config.allowUnfree = true;
  overlays = with inputs; [
    fenix.overlays.default
    figsoda-pkgs.overlays.default
  ];
}
