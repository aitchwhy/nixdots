# Configuration options for nixdots
{ lib, config, ... }:

with lib;

{
  options.nixdots = {
    # Profile selection
    profile = mkOption {
      type = types.enum [ "minimal" "development" "full" ];
      default = "development";
      description = "Configuration profile to use";
    };

    # Feature toggles
    features = {
      development = {
        enable = mkEnableOption "development tools and languages";
        languages = {
          go = mkEnableOption "Go development" // { default = true; };
          rust = mkEnableOption "Rust development" // { default = true; };
          node = mkEnableOption "Node.js development" // { default = true; };
          python = mkEnableOption "Python development" // { default = true; };
          ruby = mkEnableOption "Ruby development" // { default = false; };
          haskell = mkEnableOption "Haskell development" // { default = false; };
        };
      };

      cloud = {
        enable = mkEnableOption "cloud and infrastructure tools";
        aws = mkEnableOption "AWS tools" // { default = true; };
        terraform = mkEnableOption "Terraform" // { default = true; };
        kubernetes = mkEnableOption "Kubernetes tools" // { default = false; };
      };

      multimedia = {
        enable = mkEnableOption "multimedia applications";
        audio = mkEnableOption "audio tools" // { default = false; };
        video = mkEnableOption "video tools" // { default = false; };
        graphics = mkEnableOption "graphics tools" // { default = false; };
      };

      productivity = {
        enable = mkEnableOption "productivity tools";
        office = mkEnableOption "office suite" // { default = false; };
        communication = mkEnableOption "communication tools" // { default = true; };
      };
    };

    # System settings
    system = {
      experimental = mkEnableOption "experimental features" // { default = false; };
      optimizeForSSD = mkEnableOption "SSD optimizations" // { default = true; };
    };

    # User settings
    user = {
      # This will be set by the user module
      name = mkOption {
        type = types.str;
        description = "Primary user name";
      };
      
      fullName = mkOption {
        type = types.str;
        description = "User's full name";
      };
      
      email = mkOption {
        type = types.str;
        description = "User's email address";
      };
    };
  };

  config = {
    # Set feature enables based on profile
    nixdots.features = mkMerge [
      (mkIf (config.nixdots.profile == "minimal") {
        development.enable = false;
        cloud.enable = false;
        multimedia.enable = false;
        productivity.enable = false;
      })
      
      (mkIf (config.nixdots.profile == "development") {
        development.enable = mkDefault true;
        cloud.enable = mkDefault true;
        multimedia.enable = mkDefault false;
        productivity.enable = mkDefault true;
      })
      
      (mkIf (config.nixdots.profile == "full") {
        development.enable = mkDefault true;
        cloud.enable = mkDefault true;
        multimedia.enable = mkDefault true;
        productivity.enable = mkDefault true;
      })
    ];
  };
}