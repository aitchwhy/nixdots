# Auto-import all package category modules
{ lib, ... }:
let
  importLib = import ../../../lib/imports.nix { inherit lib; };
in
{
  imports = importLib.autoImport ./.;
}
