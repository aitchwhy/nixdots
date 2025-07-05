# NixOS-specific system configuration
{ config, lib, pkgs, ... }:
{
  imports = [
    ../shared/defaults.nix
  ];

  # NixOS-specific settings
  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };

  # Enable the X11 windowing system
  services.xserver = {
    enable = lib.mkDefault false;
    displayManager.gdm.enable = lib.mkDefault false;
    desktopManager.gnome.enable = lib.mkDefault false;
  };

  # Enable networking
  networking = {
    networkmanager.enable = lib.mkDefault true;
  };

  # System packages for NixOS
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = lib.mkDefault "24.05";
}