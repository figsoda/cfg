{ lib, pkgs }:

let
  python = (pkgs.python3.withPackages (p: [ p.pytaglib ])).interpreter;
in

pkgs.writers.writeDashBin "ymdl" /* sh */ ''
  ${lib.getExe pkgs.yt-dlp} --format bestaudio/flac/best \
    -x --audio-format flac --audio-quality 0 --add-metadata \
    -o "%(track)s@%(title)s@%(artist)s@%(creator)s@%(channel)s@%(uploader)s.%(ext)s" \
    --exec "${python} ${./postdl.py} {}" \
    "$@"
''
