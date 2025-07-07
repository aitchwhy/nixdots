# Legacy compatibility - redirects to modular darwin configuration
{ config, lib, pkgs, ... }:

{
  imports = [ ./darwin/default.nix ];
}
