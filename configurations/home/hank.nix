{ flake, ... }:
let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.default
  ];

  # Defined by /modules/home/me.nix
  # And used all around in /modules/home/*
  me = {
    username = "hank";
    fullname = "Hank Lee";
    email = "hank.lee.qed@gmail.com";
  };

  home.stateVersion = "24.11";

  home.shellAliases = {
    cat = "bat --paging=always";
    cs = "claude squad";
    d = "docker";
    dc = "docker-compose";
    diff = "delta";
    find = "fd";
    g = "git";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    grep = "rg";
    gs = "git status";
    j = "just";
    e = "$EDITOR";
    lg = "lazygit";
    ll = "eza -lahF --git";
    ls = "eza --git --icons";
    nb = "nix build";
    nd = "nix develop";
    ndz = "nix develop --command zsh";
    nf = "nix flake";
    nr = "nix run";
    pc = "process-compose";
    ps = "procs";
    sp = "supabase";
    ts = "tailscale";
    zj = "zellij";
  };

}
