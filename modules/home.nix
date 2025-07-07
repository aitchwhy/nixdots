# Home Manager module - user environment configuration
# This file contains:
# - Common CLI tools and utilities for all users
# - Shell configurations and integrations
# - General productivity tools
# - Does NOT include: language-specific tools, cloud CLIs, or user-specific preferences
{ config, pkgs, lib, ... }:
{
  # Home-manager settings
  programs.home-manager.enable = true;

  # Version - required by home-manager
  home.stateVersion = "24.11";

  # Core CLI tools for all users
  home.packages = with pkgs; [
    # Essential CLI tools
    just
    # neovim is configured as a program below
    # tmux is configured as a program below

    # Modern Unix replacements
    ripgrep # Better grep
    fd # Better find
    # bat is configured as a program below
    # eza is configured as a program below
    delta # Better diff
    sd # Better sed
    dust # Better du
    procs # Better ps
    bottom # Better top

    # Data processing
    jq # JSON processor
    yq # YAML processor
    # fzf is configured as a program below

    # System monitoring
    htop
    btop
    ncdu
    tree

    # Network tools
    wget
    curl

    # File management
    watchman # File watcher

    # Git enhancements
    # git-lfs is configured via git program below
    lazygit # Git TUI
    commitizen # Conventional commits
  ];

  # Shell configuration
  programs = {
    # Zsh - modern shell with great features
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      initExtra = ''
        # Fast directory navigation
        setopt AUTO_CD
        setopt AUTO_PUSHD
        setopt PUSHD_IGNORE_DUPS
        setopt PUSHD_SILENT

        # Better history
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_FIND_NO_DUPS
        setopt HIST_SAVE_NO_DUPS
        setopt SHARE_HISTORY

        # Modern completions
        setopt MENU_COMPLETE
        setopt AUTO_LIST
        setopt COMPLETE_IN_WORD
      '';

      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };
    };

    # Minimal, fast prompt
    starship = {
      enable = true;
      settings = {
        format = "$username$hostname$directory$git_branch$git_status$cmd_duration$line_break$character";

        add_newline = false;

        directory = {
          truncation_length = 3;
          truncate_to_repo = true;
          style = "bold cyan";
        };

        git_branch = {
          symbol = " ";
          style = "bold purple";
        };

        git_status = {
          disabled = false;
          style = "bold red";
        };

        cmd_duration = {
          min_time = 500;
          format = " [$duration]($style)";
          style = "bold yellow";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold green)";
        };
      };
    };

    # Essential developer tools
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    # Fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--border sharp"
        "--layout reverse"
        "--info inline"
        "--preview-window=:hidden"
        "--bind='ctrl-/:toggle-preview'"
      ];
    };

    # Modern file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    # Smart directory jumping
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    # Git essentials
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          navigate = true;
          light = false;
          line-numbers = true;
          side-by-side = true;
        };
      };

      lfs.enable = true;

      ignores = [
        ".DS_Store"
        "*.swp"
        "*.swo"
        "*~"
        ".env.local"
        ".direnv"
        "node_modules"
        "target"
        "dist"
        ".idea"
        ".vscode"
        "*.log"
      ];

      aliases = {
        # Essential shortcuts only
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        merge.conflictStyle = "zdiff3";
        rerere.enabled = true;

        branch.sort = "-committerdate";

        # Performance
        core = {
          preloadindex = true;
          fscache = true;
          untrackedcache = true;
        };

        # Better diffs
        diff = {
          algorithm = "histogram";
          colorMoved = "default";
          colorMovedWS = "ignore-all-space";
        };

        # Credentials
        credential.helper = "osxkeychain";
      };
    };

    # Modern Unix replacements
    eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };

    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR";
      };
    };

    # Terminal multiplexer
    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      historyLimit = 50000;
      keyMode = "vi";
      mouse = true;
      terminal = "screen-256color";

      prefix = "C-a";

      extraConfig = ''
        # Better colors
        set -ga terminal-overrides ",*256col*:Tc"

        # Faster key repetition
        set -sg repeat-time = 0

        # Focus events
        set -g focus-events on

        # Status bar
        set -g status-position top
        set -g status-style 'bg=#1e1e2e fg=#cdd6f4'
        set -g status-left-length 20

        # Easy split panes
        bind | split-window -h
        bind - split-window -v
      '';
    };

    # Shell integration
    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    # Bash configuration
    bash = {
      enable = true;
      enableCompletion = true;
    };

    # Editor
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # Modern shell history
    atuin = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        search_mode = "fuzzy";
        style = "compact";
      };
    };
  };

  # Streamlined aliases
  home.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    ll = "ls -l";
    la = "ls -la";
    lt = "ls -la --tree";

    # Git
    g = "git";
    gs = "git status";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    gc = "git commit";
    gco = "git checkout";
    gaa = "git add --all";

    # Docker
    d = "docker";
    dc = "docker compose";
    dps = "docker ps";

    # Nix
    rebuild = "darwin-rebuild switch --flake ~/.config/nix-darwin";
    update = "nix flake update";
    clean = "nix-collect-garbage -d";
    search = "nix search nixpkgs";

    # Quick edits
    e = "$EDITOR";
    se = "sudo $EDITOR";

    # Productivity
    cat = "bat";
    find = "fd";
    grep = "rg";
    ls = "eza";
    tree = "eza --tree";
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    PAGER = "less -FR";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    # Development
    HOMEBREW_NO_ANALYTICS = "1";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    GATSBY_TELEMETRY_DISABLED = "1";
    NEXT_TELEMETRY_DISABLED = "1";

    # Performance
    DIRENV_LOG_FORMAT = "";

    # Better defaults
    LESS = "-FR";
    SYSTEMD_LESS = "-FR";
  };
}
