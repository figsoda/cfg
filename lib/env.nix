{ config, lib, pkgs, ... }: {
  environment = {
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=/dev/null
      DOCUMENTS=files
      DOWNLOAD=files
      MUSIC=music
      PICTURES=files
      PUBLICSHARE=/dev/null
      TEMPLATES=/dev/null
      VIDEOS=files
    '';
    variables = {
      LESSHISTFILE = "-";
      PATH = "$HOME/.cargo/bin";
      RIPGREP_CONFIG_PATH = "${pkgs.writeText "rg-config" ''
        -S
        -g=!.git
        --hidden
      ''}";
    };
  };
}
