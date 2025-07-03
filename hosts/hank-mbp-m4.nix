{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking.hostName = "hank-mbp-m4";
  system.stateVersion = 4;

  # Tailscale
  services.tailscale.enable = true;

  # Backup file extension for home-manager
  home-manager.backupFileExtension = "nixos-unified-template-backup";
}
