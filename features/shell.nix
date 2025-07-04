{ config, lib, pkgs, ... }:
{
  # System packages available to all users
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils
    gnumake
    git
    just

    # Modern CLI tools
    ripgrep
    fd
    bat
    eza
    delta

    # Development tools
    direnv
    nix-direnv

    # File management
    wget
    curl
    tree

    # Platform-specific additions
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    darwin.trash
  ];

  # Enable zsh on all systems
  programs.zsh.enable = true;

  # Shell configuration
  environment = {
    shells = with pkgs; lib.mkIf pkgs.stdenv.isDarwin [
      bashInteractive
      zsh
    ];

    # Common environment variables (additional to those in shared/defaults.nix)
    variables = {
      # EDITOR and VISUAL are set in shared/defaults.nix
      # PAGER is also set there
    };
  };

  # Enable TouchID for sudo on macOS
  security.pam.services.sudo_local = lib.mkIf pkgs.stdenv.isDarwin {
    touchIdAuth = true;
  };
}
