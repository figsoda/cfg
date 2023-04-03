{ pkgs }:

{
  fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "JetBrainsMono Nerd Font" "Cascadia Code" "Sarasa Mono SC" ];
      sansSerif = [ "Arimo Nerd Font" "Sarasa Gothic SC" ];
      serif = [ "Arimo Nerd Font" "Sarasa Gothic SC" ];
    };
    includeUserConf = false;
  };
  fonts = with pkgs; [
    cascadia-code
    (nerdfonts.override { fonts = [ "Arimo" "JetBrainsMono" ]; })
    noto-fonts-emoji
    sarasa-gothic
  ];
}
