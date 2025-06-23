{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    omnix
    yazi

    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    gnumake

    # Nix dev
    cachix
    nom # nix build visualizer
    nil # Nix language server
    nix-info
    nixpkgs-fmt


    # Developer tools
    gh # GitHub CLI
    nix-info
    nixpacks
    deadnix
    yazi
    yaziPlugins.nord
    yaziPlugins.git
    yaziPlugins.rsync
    yaziPlugins.mactag
    yaziPlugins.glow
    comma

    # On ubuntu, we need this less for `man home-configuration.nix`'s pager to
    # work.
    less

    nix-output-monitor

    # Programming languages
    uv

  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    # Better `cat`
    bat.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
    # Tmate terminal sharing.
    tmate = {
      enable = true;
      #host = ""; #In case you wish to use a server other than tmate.io
    };

    zellij = {
      enable = true;
      settings = {
        theme = "tokyo-night";
        default_shell = "zsh";
        default_layout = "main";
      };
      enableZshIntegration = true;
    };

    yazi = {
      enable = true;
      settings = {
        theme = "tokyo-night";
      };
    };

  };
}
