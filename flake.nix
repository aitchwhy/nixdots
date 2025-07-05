{
  description = "Hank's Nix Configuration";

  inputs = {
    # Principle inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Software inputs
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , ...
    }@inputs:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Home modules
      homeModules = {
        default = ./modules/home.nix;
      };

      # Darwin configurations
      darwinConfigurations = {
        hank-mbp-m4 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            # Core modules
            ./modules/nix.nix
            ./modules/darwin.nix
            ./modules/homebrew.nix
            
            # Machine configuration
            ./machines/hank-mbp-m4.nix
            
            # Inline user definition
            ({ pkgs, ... }: {
              users.users.hank = {
                description = "Hank Lee";
                home = "/Users/hank";
                shell = pkgs.zsh;
              };
              
              # Enable zsh
              programs.zsh.enable = true;
              
              # Shell packages
              environment.systemPackages = with pkgs; [
                ripgrep fd bat eza delta
                direnv nix-direnv
                wget curl tree jq yq-go
              ];
              
              environment.shells = with pkgs; [ bashInteractive zsh ];
            })
            
            # Home-manager integration
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; self = inputs.self; };
                users.hank = import ./users/hank.nix;
              };
            }
          ];
        };
      };

      # Development shells
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              just
              nixd
              nixpkgs-fmt
              ripgrep
              fd
              bat
              delta
              yazi
              zoxide
            ];
          };
        }
      );

      # Formatter
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
    };
}
