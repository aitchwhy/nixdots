# Compatibility wrapper for the flake's dev shell
(import (
  let
    lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  in
  fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  }
) { }).mkShell {
  shellHook = ''
    echo "Note: This is a compatibility shell.nix"
    echo "For the full development environment, use: nix develop"
  '';
  
  packages = [
    # Basic tools for bootstrapping
    just
    nixd
    nixpkgs-fmt
  ];
}