{ pkgs }:

let
  inherit (pkgs)
    delta
    libsecret
    writeText
    writers
    ;
in

{
  core = {
    fsmonitor = true;
    pager = "${delta}/bin/delta";
    excludesFile = writeText ".gitignore" ''
      /root.img
    '';
  };
  credential."https://github.com" = {
    username = "figsoda";
    helper = writers.writeBash "credential-helper-github" ''
      if [ "$1" = get ]; then
        echo -n password=
        ${libsecret}/bin/secret-tool lookup github git
      fi
    '';
  };
  delta = {
    hunk-header-decoration-style = "blue";
    line-number = true;
    syntax-theme = "OneHalfDark";
  };
  features.manyFiles = true;
  http.postBuffer = 32 * 1024 * 1024;
  init.defaultBranch = "main";
  interactive.diffFilter = "${delta}/bin/delta --color-only";
  url = {
    "https://gitlab.com/".insteadOf = [
      "gl:"
      "gitlab:"
    ];
    "https://github.com/".insteadOf = [
      "gh:"
      "github:"
    ];
    "https://github.com/figsoda/".insteadOf = [ "me:" ];
    "https://github.com/nix-community/".insteadOf = [ "nc:" ];
  };
  user = {
    name = "figsoda";
    email = "figsoda@pm.me";
  };
}
