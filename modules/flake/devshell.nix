{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      name = "nixos-unified-template-shell";
      meta.description = "Shell environment for modifying this Nix configuration";
      packages = with pkgs; [
        just
        nixd
        ripgrep
        fd
        bat
        delta
        yazi
        zellij
        zoxide
      ];
    };
  };
}
