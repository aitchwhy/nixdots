# Sensible defaults for all systems
{ config, lib, pkgs, ... }:
{
  # Time zone
  time.timeZone = lib.mkDefault "America/New_York";
  
  # Common shell aliases
  environment.shellAliases = {
    # Nix shortcuts
    nrs = "darwin-rebuild switch --flake .";
    nrb = "darwin-rebuild build --flake .";
    nfu = "nix flake update";
    nfc = "nix flake check";
    nfmt = "nix fmt";
    
    # Modern tool aliases
    ls = "eza";
    ll = "eza -la";
    la = "eza -a";
    lt = "eza --tree";
    cat = "bat";
    grep = "rg";
    find = "fd";
  };
  
  # Environment variables
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
    BAT_THEME = "TwoDark";
  };
}
