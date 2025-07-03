# Sensible defaults for all systems
{ config, lib, pkgs, ... }:
{
  # Time zone defaults
  time.timeZone = lib.mkDefault "America/New_York";
  
  # Shell aliases that don't conflict with features/shell.nix
  environment.shellAliases = lib.mkDefault {
    nrs = "darwin-rebuild switch --flake .";
    nrb = "darwin-rebuild build --flake .";
  };
}