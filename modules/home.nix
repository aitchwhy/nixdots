# Legacy compatibility - redirects to modular home configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./home/default.nix ];
}
