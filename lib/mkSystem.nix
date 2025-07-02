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
        
        # Darwin-specific features
        ../features/homebrew.nix
        
        # Host configuration
        ../hosts/${hostname}.nix
        
        # Home-manager integration
        inputs.home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
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
        ../hosts/${hostname}.nix
        
        # Home-manager integration
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users = users;
          };
        }
      ];
    };
}