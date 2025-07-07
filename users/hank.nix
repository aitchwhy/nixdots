# User-specific configuration
# This file contains:
# - Personal development tools and language toolchains
# - Cloud platform CLIs and infrastructure tools
# - User-specific Git configuration
# - Personal productivity tools
{ config, pkgs, lib, inputs, self, ... }:
{
  # Import home modules
  imports = [ self.homeModules.default ];

  # User identity
  home = {
    username = "hank";
    homeDirectory = "/Users/hank";
    stateVersion = "24.11";
  };

  # Git configuration
  programs.git = {
    userName = "Hank Lee";
    userEmail = "hank.lee.qed@gmail.com";
  };

  # User-specific packages
  home.packages = with pkgs; [
    # Cloud Platforms
    awscli2
    azure-cli
    flyctl
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])

    # Kubernetes & Infrastructure
    kubectl
    kubectx
    kubernetes-helm
    k9s
    terraform
    terragrunt
    pulumi

    # Container Tools
    docker-client
    docker-compose
    dive

    # Programming Languages & Tools
    # Node.js - using latest LTS
    nodejs_22
    nodePackages.pnpm
    yarn-berry
    bun

    # Python - using uv for fast package management
    python312
    uv
    ruff
    poetry

    # Go
    go_1_22
    gopls
    golangci-lint

    # Rust - via rustup for toolchain management
    rustup

    # Database Clients
    postgresql_16
    mysql84
    mongosh
    redis
    usql

    # API Development
    httpie
    insomnia
    grpcurl

    # Documentation
    glow
    pandoc

    # Media Processing
    ffmpeg-full
    imagemagick

    # Security Tools
    sops
    age
    gnupg
    _1password-cli

    # Code Quality & Formatting
    # Shell
    shellcheck
    shfmt

    # Nix
    nixpkgs-fmt
    alejandra
    deadnix
    statix

    # Multi-language
    dprint
    treefmt

    # Development Tools
    # Nix-specific
    cachix
    devenv
    nixd
    nil
    nix-tree
    nix-output-monitor
    nix-diff

    # Additional CLI Tools
    mkcert # Local HTTPS certs
    ngrok # Expose local servers
    caddy # Modern web server

    # GitHub
    gh
    act # Run GitHub Actions locally
  ];

  # Language-specific configurations
  home.sessionVariables = {
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
    PNPM_HOME = "$HOME/.pnpm";
  };

  home.sessionPath = [
    "$GOPATH/bin"
    "$CARGO_HOME/bin"
    "$PNPM_HOME"
    "$HOME/.local/bin"
  ];
}
