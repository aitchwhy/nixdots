# Shell aliases configuration
{ ... }:
{
  home.shellAliases = {
    # Basic shortcuts
    cat = "bat --paging=always";
    cs = "claude squad";
    d = "docker";
    dc = "docker-compose";
    diff = "delta";
    find = "fd";
    grep = "rg";
    j = "just";
    e = "$EDITOR";
    lg = "lazygit";
    ll = "eza -lahF --git";
    ls = "eza --git --icons";
    ps = "procs";
    sp = "supabase";
    ts = "tailscale";
    zj = "zellij";
    claude = "/Users/hank/.claude/local/claude";

    # Git shortcuts
    g = "git";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gs = "git status";

    # Nix shortcuts
    nb = "nix build";
    nd = "nix develop";
    nz = "nix develop --command zsh";
    nf = "nix flake";
    np = "nix profile";
    nr = "nix run";

    # Process compose
    pc = "process-compose";
  };
}
