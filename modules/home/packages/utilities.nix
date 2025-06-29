# Core utilities and file management tools
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Core utilities
    coreutils
    curl
    wget
    tree
    less # Pager for man pages

    # File management and search
    ripgrep # Fast grep (rg)
    fd # Fast find
    sd # Find and replace
    eza # Better ls
    bat # Better cat with syntax highlighting
    hexyl # Hex viewer
    ls-lint

    # File operations
    ouch # Compression/decompression
    p7zip # 7-zip archives

    # System monitoring
    dust # Disk usage analyzer
    procs # Better ps
    lnav # Log file navigator

    # Documentation
    tlrc # tldr client

    # Version control
    git-extras
    git-filter-repo

    # Other CLI tools
    omnix # Nix tooling
  ];
}
