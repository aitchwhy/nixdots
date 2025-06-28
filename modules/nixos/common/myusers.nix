# Darwin-specific user configuration that extends the shared module
{ flake, pkgs, lib, config, ... }:
let
  inherit (flake.inputs) self;
  mapListToAttrs = m: f:
    lib.listToAttrs (map (name: { inherit name; value = f name; }) m);
in
{
  imports = [
    (self + /modules/shared/myusers.nix)
  ];

  config = {
    # Darwin-specific user configuration
    # For home-manager to work on Darwin
    # https://github.com/nix-community/home-manager/issues/4026#issuecomment-1565487545
    users.users = mapListToAttrs config.myusers (name: {
      home = "/Users/${name}";
    });

    # Darwin-specific Nix settings
    # See https://github.com/LnL7/nix-darwin/issues/96
    ids.gids.nixbld = 350;
  };
}