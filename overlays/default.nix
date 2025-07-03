# Package overlays for customizing nixpkgs
{ inputs, ... }:
{
  # Add overlays here
  # Example:
  # modifications = final: prev: {
  #   somePackage = prev.somePackage.overrideAttrs (oldAttrs: {
  #     version = "custom";
  #   });
  # };
}