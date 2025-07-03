{ inputs }:
{
  mkDarwin = { hostname, system, users }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        # Core features always included
        ../features/nix.nix
        ../features/shell.nix
        ../features/users.nix

        # Darwin modules (includes homebrew)
        ../modules/darwin

        # Host configuration
        ../machines/${hostname}.nix

        # Home-manager integration
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; self = inputs.self; };
            users = users;
          };
        }
      ];
    };

  mkNixOS = { hostname, system, users }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        # Core features always included
        ../features/nix.nix
        ../features/shell.nix
        ../features/users.nix

        # Host configuration
        ../machines/${hostname}.nix

        # Home-manager integration
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; self = inputs.self; };
            users = users;
          };
        }
      ];
    };
}
