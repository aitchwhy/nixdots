# Core home-manager configuration
{ config, pkgs, lib, ... }:
{
  # Home-manager settings
  programs.home-manager.enable = true;

  # Shell configuration
  programs = {
    # Zsh
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
    };

    # Better shell prompt
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };

    # Directory environment management
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global = {
        hide_env_diff = true;
      };
    };

    # Shell history
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "1440";
        style = "tokyo-night";
      };
    };

    # Fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--border"
        "--preview-window=:hidden"
        "--preview 'bat --color=always {}'"
      ];
    };

    # Terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = {
        theme = "tokyo-night";
      };
    };

    # Better cd
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Git configuration
    git = {
      enable = true;
      delta.enable = true;
      lfs.enable = true;
      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
        "node_modules"
        "dist"
        "build"
        "out"
        "target"
        "tmp"
        ".env"
        ".env.local"
      ];
      aliases = {
        b = "branch";
        c = "commit";
        co = "checkout";
        d = "diff";
        l = "log";
        ll = "pull";
        p = "push";
        s = "status";
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        rerere.enabled = true;
        fetch.prune = true;
        diff.colorMoved = "zebra";
        merge.conflictStyle = "zdiff3";
      };
    };

    # GitHub CLI
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    # Lazygit
    lazygit = {
      enable = true;
      settings.diff.context = 10;
    };

    # Modern Unix tools
    eza.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    bat.enable = true;
    jq.enable = true;
    
    # Development tools
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    # Terminal multiplexers
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      terminal = "tmux-256color";
    };

    zellij = {
      enable = true;
      settings = {
        theme = "tokyo-night";
      };
    };

    # Shell completion
    nix-index.enable = true;
    
    # Python environment management
    uv.enable = true;
    
    # Database client
    pgcli.enable = true;
  };

  # Shell aliases
  home.shellAliases = {
    # Basic shortcuts
    cat = "bat --paging=never";
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
    gaa = "git add --all";
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
    nrs = "darwin-rebuild switch --flake .";
    nrb = "darwin-rebuild build --flake .";
    nfu = "nix flake update";
    nfc = "nix flake check";
    nfmt = "nix fmt";
    
    # Process compose
    pc = "process-compose";
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less";
    LESS = "-R";
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };
}