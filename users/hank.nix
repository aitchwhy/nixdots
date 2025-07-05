{ config, pkgs, lib, inputs, self, ... }:
{
  # Import all home modules
  imports = [ self.homeModules.default ];

  # User identity configuration
  me = {
    username = "hank";
    fullname = "Hank Lee";
    email = "hank.lee.qed@gmail.com";
  };

  # Home directory configuration
  home = {
    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isDarwin then "/Users/hank"
      else "/home/hank"
    );
    stateVersion = "24.11";
  };


  # Platform-specific packages
  home.packages = with pkgs; lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific packages
    claude-code
  ];
}
