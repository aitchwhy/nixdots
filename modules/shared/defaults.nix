# Sensible defaults for all systems
{ config, lib, pkgs, ... }:
{
  # Nix configuration defaults
  nix = {
    settings = {
      # Enable experimental features
      experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
      
      # Optimize storage automatically
      auto-optimise-store = lib.mkDefault true;
      
      # Trusted users
      trusted-users = lib.mkDefault [ "root" "@wheel" ];
      
      # Substituters for faster builds
      substituters = lib.mkDefault [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = lib.mkDefault [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      
      # Garbage collection
      min-free = lib.mkDefault (1 * 1024 * 1024 * 1024); # 1GB
      max-free = lib.mkDefault (5 * 1024 * 1024 * 1024); # 5GB
    };
    
    # Garbage collection schedule
    gc = {
      automatic = lib.mkDefault true;
      interval = lib.mkDefault { Hour = 3; Minute = 0; }; # 3 AM daily
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };

  # Time zone and locale defaults
  time.timeZone = lib.mkDefault "America/New_York";
  
  # Environment defaults
  environment = {
    # Default system packages
    systemPackages = with pkgs; lib.mkDefault [
      vim
      git
      curl
      wget
    ];
    
    # Shell aliases
    shellAliases = lib.mkDefault {
      l = "ls -la";
      ll = "ls -l";
      la = "ls -a";
      g = "git";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      gl = "git log";
      nrs = "darwin-rebuild switch --flake .";
      nrb = "darwin-rebuild build --flake .";
    };
  };

  # Program defaults
  programs = {
    # Enable zsh by default
    zsh = {
      enable = lib.mkDefault true;
      enableCompletion = lib.mkDefault true;
      enableSyntaxHighlighting = lib.mkDefault true;
    };
  };

  # Security defaults (only on NixOS)
  security = lib.mkIf (!pkgs.stdenv.isDarwin) {
    # Security settings for NixOS systems
  };
}