{ config, pkgs, lib, inputs, self, ... }:
{
  # Import home modules
  imports = [ self.homeModules.default ];

  # User identity
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
    userName = "Hank Lee";
    userEmail = "hank.lee.qed@gmail.com";
  };

  # User packages
  home.packages = with pkgs; [
    # Cloud & Infrastructure
    awscli2
    flyctl
    terraform
    pulumi
    skopeo
    podman
    trivy
    sops
    gitleaks
    caddy
    speedtest-cli
    rustscan
    
    # Data Processing
    yq
    jo
    fx
    jtbl
    miller
    pandoc
    httpie
    hurl
    xh
    usql
    datasette
    glow
    goaccess
    
    # Development Tools
    cachix
    nil
    nixd
    nix-info
    nixpkgs-fmt
    deadnix
    nix-output-monitor
    nix-tree
    editorconfig-core-c
    shellcheck
    shfmt
    go
    bun
    rustup
    ruby_3_3
    ghc
    nodejs
    dprint
    entr
    dive
    commitizen
    lefthook
    semgrep
    trufflehog
    coder
    
    # Media & Documents
    ffmpeg
    imagemagick
    poppler
    tesseract
    resvg
    tectonic
    slack
    
    # System Utilities
    coreutils
    curl
    wget
    tree
    less
    sd
    hexyl
    ls-lint
    ouch
    p7zip
    f2
    dust
    procs
    lnav
    tlrc
    git-extras
    git-filter-repo
    omnix
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    # macOS-specific
    claude-code
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # Linux-specific
    parsec-bin
  ];
}
