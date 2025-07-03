_:
{


  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
        alias pc="process-compose"
      '';
    };

    # For macOS's default shell.
    zsh = {
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
        alias pc="process-compose"
      '';
    };

    # Type `z <pat>` to cd to some directory
    zoxide = {
      enable = true;
    };

    # Better shell prompt!
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
          ssh_symbol = "🌐 ";
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
    };

    # Shell history
    atuin = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Fuzzy finder
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Terminal file manager
    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    # Better ls replacement
    eza = {
      enable = true;
    };

    # Python environment management
    uv = {
      enable = true;
    };

    # Text editor
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };

    # Modern replacements for Unix tools
    ripgrep = {
      enable = true;
    };

    fd = {
      enable = true;
    };

    # Shell completion
    nix-index = {
      enable = true;
    };

    # Database clients
    pgcli = {
      enable = true;
    };



  };

  services = {
    ollama.enable = true;
  };
}
