# List of users for darwin or nixos system and their top-level configuration.
{ flake, pkgs, lib, config, ... }:
let
  inherit (flake.inputs) self;
  mapListToAttrs = m: f:
    lib.listToAttrs (map (name: { inherit name; value = f name; }) m);
in
{
  options = {
    myusers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of usernames";
      defaultText = "All users under ./configuration/users are included by default";
      default =
        let
          dirContents = builtins.readDir (self + /configurations/home);
          fileNames = builtins.attrNames dirContents; # Extracts keys: [ "hank.nix" ]
          regularFiles = builtins.filter (name: dirContents.${name} == "regular") fileNames; # Filters for regular files
          baseNames = map (name: builtins.replaceStrings [ ".nix" ] [ "" ] name) regularFiles; # Removes .nix extension
        in
        baseNames;
    };
  };

  config = {
    # For home-manager to work.
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users = mapListToAttrs config.myusers (name:
      lib.optionalAttrs pkgs.stdenv.isDarwin
        {
          home = "/Users/${name}";
        } // lib.optionalAttrs pkgs.stdenv.isLinux {
        isNormalUser = true;
      }
    );

    # Enable home-manager for our user
    home-manager.users = mapListToAttrs config.myusers (name: {
      imports = [ (self + /configurations/home/${name}.nix) ];
    });

    # All users can add Nix caches.
    nix.settings.trusted-users = [
      "root"
    ] ++ config.myusers;

    nix.optimise.automatic = true;

    # nix.optimise.automatic = true;
    nix.checkConfig = true;

    nix.settings = {
      sandbox = true;
      experimental-features = "nix-command flakes";
      allow-dirty = true;
      download-buffer-size = 256 * 1024 * 1024; # 256MiB
      always-allow-substitutes = true;

      max-jobs = "auto";
    };

    # See https://github.com/LnL7/nix-darwin/issues/96
    ids.gids.nixbld = 350;

    # FlakeHub cache
    nix.settings."extra-trusted-substituters" = [ "https://cache.flakehub.com" ];
    nix.settings."extra-trusted-public-keys" = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio="
      "cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU="
      "cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU="
      "cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8="
      "cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ="
      "cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o="
      "cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y="
    ];
  };
}
