{ config, pkgs, lib, inputs, ... }:
{
  home = {
    username = "hank";
    homeDirectory = lib.mkDefault (
      if pkgs.stdenv.isDarwin then "/Users/hank"
      else "/home/hank"
    );
    stateVersion = "24.11";
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Hank Lee";
    userEmail = "hank.lee.qed@gmail.com";

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
    };

    delta.enable = true;
    lfs.enable = true;
  };

  # GitHub CLI
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  # Shell configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    envExtra = ''
      # Custom ~/.zshenv goes here
      export EDITOR=nvim
    '';

    profileExtra = ''
      # Custom ~/.zprofile goes here
    '';

    loginExtra = ''
      # Custom ~/.zlogin goes here
    '';

    logoutExtra = ''
      # Custom ~/.zlogout goes here
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # Custom bash profile goes here
    '';
  };

  # Better shell tools
  programs.zoxide.enable = true;
  programs.starship.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.hide_env_diff = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "1440";
      style = "tokyo-night";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      theme = "tokyo-night";
    };
  };

  # Terminal tools
  programs.eza.enable = true;
  programs.bat.enable = true;
  programs.jq.enable = true;
  programs.htop.enable = true;
  programs.fastfetch.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  # Git UI tools
  programs.lazygit = {
    enable = true;
    settings.diff.context = 10;
  };
  programs.lazydocker.enable = true;

  # Terminal multiplexers
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "screen-256color";
  };

  programs.zellij = {
    enable = true;
    settings = {
      theme = "tokyo-night";
      default_shell = "zsh";
    };
  };

  # Terminal sharing
  programs.tmate.enable = true;

  # Text editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # NixVim configuration (if using)
  programs.nixvim = lib.mkIf (builtins.hasAttr "nixvim" inputs) {
    enable = true;
    colorschemes.tokyonight.enable = true;

    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      clipboard = "unnamedplus";
    };

    globals.mapleader = " ";

    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      which-key.enable = true;
      telescope.enable = true;
      lazygit.enable = true;

      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          marksman.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
    };
  };

  # Database clients
  programs.pgcli.enable = true;

  # Python environment management
  programs.uv.enable = true;

  # Shell aliases
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
    nz = "nix develop --command zsh";
    nf = "nix flake";
    np = "nix profile";
    nr = "nix run";
    pc = "process-compose";
    ps = "procs";
    sp = "supabase";
    ts = "tailscale";
    zj = "zellij";
    claude = "/Users/hank/.claude/local/claude";
  };

  # Home packages
  home.packages = with pkgs; [
    # Nix development
    cachix
    nil
    nixd
    nix-info
    nixpkgs-fmt
    deadnix
    nix-output-monitor
    nix-tree
    omnix

    # Core development tools
    gnumake
    editorconfig-core-c
    entr
    just
    dive
    commitizen
    lefthook
    semgrep
    ls-lint

    # Shell and scripting
    shellcheck
    shfmt

    # Languages and runtimes
    go
    bun
    rustup
    ruby_3_3
    ghc
    nodejs

    # Language tools
    dprint

    # Cloud platforms
    awscli2
    flyctl
    terraform
    pulumi

    # Container tools
    skopeo
    podman
    trivy

    # Secrets and security
    sops
    gitleaks

    # Networking
    caddy
    speedtest-cli
    rustscan

    # Data processing
    jq
    yq
    jo
    fx
    miller
    pandoc

    # HTTP clients
    httpie
    hurl
    xh

    # Database tools
    usql
    datasette

    # Text processing
    glow
    goaccess

    # File operations
    ouch
    p7zip
    sd
    hexyl

    # System monitoring
    dust
    procs
    lnav

    # Documentation
    tlrc

    # Version control
    git-extras
    git-filter-repo

    # Media processing
    ffmpeg
    imagemagick
    poppler
    tesseract

    # Applications
    parsec-bin
    slack
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific packages
    claude-code
  ];

  # Services
  services.ollama.enable = lib.mkDefault pkgs.stdenv.isLinux;

  # Nix-index database
  programs.nix-index-database.comma.enable = true;
}
