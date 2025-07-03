# Development tools and programming languages
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Nix development
    cachix
    nil # Nix language server
    nixd
    nix-info
    nixpkgs-fmt
    deadnix
    nix-output-monitor
    nix-tree

    # Core development tools
    gnumake
    editorconfig-core-c

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
    dprint # Multi-language formatter

    # Development utilities
    entr # File watcher
    just # Command runner
    dive # Docker layer explorer
    commitizen # Conventional commits
    lefthook # Git hooks
    semgrep # Static analysis

    ls-lint # Linting files + dirs names
    
    # Security and analysis
    trufflehog # Secret scanning
    
    # Remote development
    coder # Remote development environments via Terraform
  ];
}
