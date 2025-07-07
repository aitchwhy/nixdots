{
  description = "Hank's Nix Configuration";

  inputs = {
    # Core inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nix-darwin
    , home-manager
    , ...
    }@inputs:
    let
      systems = [ "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Helper to get packages for a system
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      # Home modules
      homeModules.default = ./modules/home.nix;

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

            # User configuration
            ({ pkgs, ... }: {
              users.users.hank = {
                description = "Hank Lee";
                home = "/Users/hank";
                shell = pkgs.zsh;
              };

              programs.zsh.enable = true;
              environment.shells = with pkgs; [ bashInteractive zsh ];
            })

            # Home-manager integration
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs self; };
                users.hank = import ./users/hank.nix;
              };
            }
          ];
        };
      };

      # Apps for common tasks
      apps = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          rebuild = pkgs.writeShellScriptBin "rebuild" ''
            set -e
            echo "🔨 Rebuilding Nix Darwin configuration..."
            darwin-rebuild switch --flake .#hank-mbp-m4 "$@"
          '';
          update = pkgs.writeShellScriptBin "update" ''
            set -e
            echo "📦 Updating flake inputs..."
            nix flake update
            echo "✅ Update complete! Run 'rebuild' to apply changes."
          '';
          fmt = pkgs.writeShellScriptBin "fmt" ''
            set -e
            echo "🎨 Formatting Nix files..."
            ${pkgs.fd}/bin/fd -e nix -E flake.lock . | while read -r file; do
              echo "  Formatting: $file"
              ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt "$file"
            done
            echo "✅ Formatting complete!"
          '';
        in
        {
          rebuild = {
            type = "app";
            program = "${rebuild}/bin/rebuild";
          };
          update = {
            type = "app";
            program = "${update}/bin/update";
          };
          fmt = {
            type = "app";
            program = "${fmt}/bin/fmt";
          };
        }
      );

      # Development shell
      devShells = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Nix development
              nixd
              nixpkgs-fmt
              deadnix
              statix

              # Utilities
              just
              git
              fd
            ];

            shellHook = ''
              echo "🚀 Nix Darwin Development Shell"
              echo ""
              echo "📝 Available commands:"
              echo "  nix run .#rebuild    - Rebuild system configuration"
              echo "  nix run .#update     - Update flake inputs"
              echo "  nix run .#fmt        - Format all Nix files"
              echo "  nix flake check      - Run all checks"
              echo "  deadnix              - Find dead code"
              echo "  statix check         - Lint Nix files"
              echo ""
              echo "📂 Configuration: $PWD"
              echo "🖥️  System: $(hostname)"
            '';
          };
        });

      # Checks
      checks = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        {
          format = pkgs.runCommand "check-format"
            {
              buildInputs = [ pkgs.fd pkgs.nixpkgs-fmt ];
            } ''
            cd ${./.}
            echo "Checking Nix file formatting..."
            ${pkgs.fd}/bin/fd -e nix -E flake.lock . -x ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check {} \;
            touch $out
          '';
        });

      # Formatter - wrapper that only formats .nix files
      formatter = forAllSystems (system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.writeShellScriptBin "nix-fmt" ''
          echo "🎨 Formatting Nix files..."
          if [ $# -eq 0 ]; then
            # No arguments, format all .nix files in current directory
            ${pkgs.fd}/bin/fd -e nix -E flake.lock . -x ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt {} \;
            echo "✅ Formatted all .nix files"
          else
            # Format specified files
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt "$@"
          fi
        ''
      );
    };
}
