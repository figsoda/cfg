{ pkgs }:

let
  inherit (pkgs.eclipses) buildEclipse eclipse-java;
in

buildEclipse {
  inherit (eclipse-java) name src;
  inherit (eclipse-java.meta) description;
}
