{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    omnix
    # Nix
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt
    deadnix
    nix-output-monitor

    # Core utilities
    gnumake
    coreutils
    curl
    wget
    tree

    # File management and search
    # yazi - moved to programs.yazi in shell.nix
    # Yazi plugins temporarily disabled due to conflicts
    # yaziPlugins.nord
    # yaziPlugins.git
    # yaziPlugins.rsync
    # yaziPlugins.mactag
    # yaziPlugins.glow
    # ripgrep - moved to programs.ripgrep in shell.nix
    # fd - moved to programs.fd in shell.nix
    sd
    # eza - moved to programs.eza in shell.nix
    dust  # Disk usage
    ouch  # Compression/decompression
    hexyl  # Hex viewer

    # Archives
    p7zip

    # System monitoring
    procs  # Better ps

    # Git and version control
    # git - moved to programs.git in shell.nix
    git-extras
    git-filter-repo
    # delta - configured via programs.git.delta in shell.nix
    # git-lfs - configured via programs.git.lfs in shell.nix
    gitleaks  # Secret scanner
    lefthook  # Git hooks
    commitizen

    # Dev tools
    # gh - moved to programs.gh in shell.nix
    # comma
    less # On ubuntu, we need this less for `man home-configuration.nix`'s pager to work.
    dive  # Docker layer explorer
    entr  # File watcher
    just  # Command runner
    httpie
    hurl  # HTTP testing
    xh  # Modern HTTP client
    editorconfig-core-c  # EditorConfig core C implementation
    shellcheck
    shfmt
    semgrep  # Static analysis
    # aider  # AI coding assistant - not in nixpkgs

    # Text processing
    jo  # JSON generator
    miller  # CSV swiss-army-knife
    pandoc
    glow  # Markdown viewer
    fx  # JSON viewer
    goaccess  # Web log analyser
    datasette  # SQLite explorer
    yq  # YAML/JSON/XML processor

    # Cloud/Infrastructure
    awscli2
    flyctl
    terraform
    pulumi
    skopeo
    sops
    trivy
    podman
    # talosctl  # Verify package name

    # Database clients
    # pgcli - moved to programs.pgcli in shell.nix
    # usql - From homebrew tap xo/xo/usql

    # Languages and package managers
    # uv - moved to programs.uv in shell.nix
    go
    bun
    rustup
    ruby_3_3
    ghc
    nodejs
    nodePackages.prettier
    nodePackages.eslint
    # Additional Node.js tools
    nodePackages.npm # npm package manager
    nodePackages.yarn # yarn package manager
    nodePackages.pnpm # pnpm package manager
    nodePackages.typescript # TypeScript compiler
    nodePackages.typescript-language-server # TypeScript LSP
    dprint

    # Media
    ffmpeg
    imagemagick
    poppler
    tesseract

    # Networking
    caddy
    speedtest-cli
    rustscan

    # Documentation
    tlrc  # tldr client

    # Log viewing
    lnav  # Log file navigator

    # Other development tools
    taplo  # TOML formatter
    # spectral-cli  # OpenAPI linter - verify package name
    # kiota  # HTTP client generator - verify availability
    # openapi-tui  # OpenAPI TUI - verify package name
    # rich-cli  # Rich text CLI - verify package name
    # tag  # Verify package name
    luarocks
    # mas  # Mac App Store CLI - verify on Darwin

    # AI/ML
    # e2b  # Verify availability in nixpkgs

    # Security tools
    # bitwarden-cli  # Currently marked as broken in nixpkgs

    # File sync
    # gdrive  # Not available in nixpkgs

    # JavaScript tools
    # nodePackages.nx  # Check if available - might need different package name

    # Terminal sharing
    # tmate - moved to programs.tmate
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    # Note: nix is not a valid programs option in home-manager

    # Better `cat`
    bat.enable = true;
    jq.enable = true;

    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
    htop.enable = true;

    # Terminal multiplexers
    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "screen-256color";
    };

    zellij = {
      enable = true;
      settings = {
        theme = "tokyo-night";
        default_shell = "zsh";
        default_layout = "main";
      };
    };

    # Tmate terminal sharing.
    tmate = {
      enable = true;
      #host = ""; #In case you wish to use a server other than tmate.io
    };

    # Git UI tools
    lazygit.enable = true;
    # lazydocker.enable = true; # Temporarily disabled - not available in nixpkgs

    # System info
    fastfetch.enable = true;

    # Nix tools
    # nix-index - moved to shell.nix to avoid duplication
  };
}
