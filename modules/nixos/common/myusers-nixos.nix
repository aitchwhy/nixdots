# NixOS-specific user configuration that extends the shared module
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
    # NixOS-specific user configuration
    users.users = mapListToAttrs config.myusers (name: {
      isNormalUser = true;
      home = "/home/${name}";
    });
  };
}
EOF < /dev/null