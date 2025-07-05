# A module that automatically imports everything else in the parent folder.
{ lib, ... }:
let
  importLib = import ../../lib/imports.nix { inherit lib; };
in
{
  imports = importLib.autoImport ./.;
}
