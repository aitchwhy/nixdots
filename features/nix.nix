{ config, lib, pkgs, inputs, ... }:
{
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "@wheel" ] ++ (lib.optionals pkgs.stdenv.isDarwin [ "@admin" ]);

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.flakehub.com"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        "cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio="
        "cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU="
        "cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU="
        "cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8="
        "cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ="
        "cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o="
        "cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y="
      ];

      # Common settings
      sandbox = true;
      allow-dirty = true;
      download-buffer-size = 256 * 1024 * 1024; # 256MiB
      always-allow-substitutes = true;
      max-jobs = "auto";
    };

    # Platform-specific optimizations
    optimise.automatic = lib.mkDefault (pkgs.stdenv.isLinux);

    # Garbage collection
    gc = {
      automatic = true;
      options = lib.mkDefault "--delete-older-than 14d";
      interval = lib.mkIf pkgs.stdenv.isDarwin { Hour = 3; Minute = 0; Weekday = 7; }; # Weekly on Sunday at 3:00 AM
    };
  };

  # Use same nixpkgs for system
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  # Platform-specific Nix settings
  ids.gids.nixbld = lib.mkIf pkgs.stdenv.isDarwin 350;
}
