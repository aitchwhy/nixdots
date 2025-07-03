{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = import ./nixvim.nix // {
    enable = true;
  };
}
