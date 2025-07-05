{ config, lib, pkgs, inputs, ... }:
{
  # System-level Nix configuration
  nix = {
    # Core settings
    package = pkgs.nix;
    settings = {
      # Enable experimental features
      experimental-features = [ "nix-command" "flakes" ];
      
      # Trust settings
      trusted-users = [ "@wheel" ] ++ (lib.optionals pkgs.stdenv.isDarwin [ "@admin" ]);
      
      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      
      # Performance tuning
      max-jobs = "auto";
      cores = 0; # Use all available cores
      sandbox = true;
      auto-optimise-store = pkgs.stdenv.isLinux;
    };
    
    # Garbage collection
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
      interval = lib.mkIf pkgs.stdenv.isDarwin {
        Hour = 3;
        Minute = 0;
        Weekday = 7; # Sunday
      };
    };
    
    # Store optimization (Linux only)
    optimise.automatic = pkgs.stdenv.isLinux;
  };
  
  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    # Only allow broken packages when explicitly needed
    allowBroken = false;
  };
  
  # Darwin-specific settings
  ids.gids.nixbld = lib.mkIf pkgs.stdenv.isDarwin 350;
}
