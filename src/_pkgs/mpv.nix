{ pkgs }:

pkgs.mpv.override {
  scripts = with pkgs.mpvScripts; [
    autoload
    sponsorblock
    thumbnail
  ];
}
