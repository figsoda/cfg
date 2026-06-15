{ pkgs }:

pkgs.writeTextDir "/share/icons/default/index.theme" /* ini */ ''
  [icon theme]
  Inherits=Qogir
''
