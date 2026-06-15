{ pkgs }:

let
  inherit (pkgs)
    libsecret
    writeText
    writers
    ;
in

{
  core.excludesFile = writeText ".gitignore" ''
    /root.img
  '';
  credential."https://github.com" = {
    username = "figsoda";
    helper = writers.writeBash "credential-helper-github" ''
      if [ "$1" = get ]; then
        echo -n password=
        ${libsecret}/bin/secret-tool lookup github git
      fi
    '';
  };
}
