{ config, lib, pkgs, ... }: {
  environment = {
    etc = {
      "xdg/mimeapps.list".text = ''
        [Default Applications]
        application/pdf=firefox.desktop
        image/bmp=sxiv.desktop
        image/gif=sxiv.desktop
        image/jpeg=sxiv.desktop
        image/jpg=sxiv.desktop
        image/png=sxiv.desktop
        image/tiff=sxiv.desktop
        image/x-bmp=sxiv.desktop
        image/x-portable-anymap=sxiv.desktop
        image/x-portable-bitmap=sxiv.desktop
        image/x-portable-graymap=sxiv.desktop
        image/x-tga=sxiv.desktop
        image/x-xpixmap=sxiv.desktop
        inode/directory=spacefm.desktop
      '';
      "xdg/user-dirs.defaults".text = ''
        DESKTOP=/dev/null
        DOCUMENTS=files
        DOWNLOAD=files
        MUSIC=music
        PICTURES=files
        PUBLICSHARE=/dev/null
        TEMPLATES=/dev/null
        VIDEOS=files
      '';
    };
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
