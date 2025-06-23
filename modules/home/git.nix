{ config, ... }:
{
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

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      userName = config.me.fullname;
      userEmail = config.me.email;
      ignores = [ "*~" "*.swp" ];
      aliases = {
        ci = "commit";
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "true";
      };
    };
    lazygit.enable = true;
  };

}
