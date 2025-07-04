# Sensible defaults for all systems
{ config, lib, pkgs, ... }:
{
  # Time zone defaults
  time.timeZone = lib.mkDefault "America/New_York";
  
  # Nix configuration defaults
  nix = {
    settings = {
      # Use all available cores for builds
      max-jobs = lib.mkDefault "auto";
      cores = lib.mkDefault 0;
      
      # Enable flakes and nix-command by default
      experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
      
      # Garbage collection settings
      min-free = lib.mkDefault (1024 * 1024 * 1024); # 1GB
      max-free = lib.mkDefault (5 * 1024 * 1024 * 1024); # 5GB
      
      # Download settings
      download-attempts = lib.mkDefault 5;
      connect-timeout = lib.mkDefault 300;
      
      # Security
      sandbox = lib.mkDefault true;
      sandbox-fallback = lib.mkDefault false;
      require-sigs = lib.mkDefault true;
      
      # Build settings
      keep-outputs = lib.mkDefault false;
      keep-derivations = lib.mkDefault false;
      auto-optimise-store = lib.mkDefault false; # Can be slow on macOS
    };
  };
  
  # Shell aliases that don't conflict with features/shell.nix
  environment.shellAliases = lib.mkDefault {
    nrs = "darwin-rebuild switch --flake .";
    nrb = "darwin-rebuild build --flake .";
    nfu = "nix flake update";
    nfc = "nix flake check";
    nfmt = "nix fmt";
  };
  
  # Environment variables
  environment.variables = {
    EDITOR = lib.mkForce "nvim";
    VISUAL = lib.mkForce "nvim";
    PAGER = lib.mkForce "less";
    LESS = lib.mkForce "-R";
  };
}