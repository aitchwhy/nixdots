{ config, lib, pkgs, ... }:
{
  # Define the primary user
  users.users.hank = lib.mkMerge [
    # Common user settings
    {
      description = "Hank Lee";
      shell = pkgs.zsh;
    }
    
    # Darwin-specific user settings
    (lib.mkIf pkgs.stdenv.isDarwin {
      home = "/Users/hank";
    })
    
    # Linux-specific user settings
    (lib.mkIf pkgs.stdenv.isLinux {
      home = "/home/hank";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      createHome = true;
    })
  ];
  
  # Set primary user on Darwin
  system.primaryUser = lib.mkIf pkgs.stdenv.isDarwin "hank";
  
  # Trust the user for Nix operations
  nix.settings.trusted-users = [ "hank" ];
}