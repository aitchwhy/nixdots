{ config, lib, pkgs, ... }:
{
  # Shell and terminal configuration shared across all systems
  
  # Enable zsh system-wide
  programs.zsh.enable = true;
  
  # Shell environment
  environment = {
    # Modern CLI tools available to all users
    systemPackages = with pkgs; [
      # Modern replacements for traditional tools
      ripgrep   # Better grep
      fd        # Better find
      bat       # Better cat
      eza       # Better ls
      delta     # Better diff
      
      # Development tools
      direnv
      nix-direnv
      
      # Essential network tools
      wget
      curl
      
      # File utilities
      tree
      jq        # JSON processor
      yq-go     # YAML processor
    ];
    
    # Configure available shells
    shells = with pkgs; [
      bashInteractive
      zsh
    ];
  };
}
