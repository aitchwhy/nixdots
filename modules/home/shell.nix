{ ... }:
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

    zellij = {
      enable = true;
      settings = {
        theme = "catppuccin";
        default_shell = "zsh";
        default_layout = "main";

      };
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

    uv = {
      enable = true;
      settings = {
        packageManager = "nix";
      };
    };

    direnv = {
      enable = true;
    };

    atuin = {
      enable = true;
    };


    # fzf = {
    #   enable = true;
    # };

    # ripgrep = {
    #   enable = true;
    # };

    # fd = {
    #   enable = true;
    # };

    # obsidian = {
    #   enable = true;
    # };


    # neovim = {
    #   enable = true;
    # };

    # lazygit = {
    #   enable = true;
    # };

    # lazydocker = {
    #   enable = true;
    # };

    # htop = {
    #   enable = true;
    # };

    # fastfetch = {
    #   enable = true;
    # };

    # git = {
    #   enable = true;
    # };

    # bat = {
    #   enable = true;
    # };

    # jq = {
    #   enable = true;
    # };

    # aerospace = {
    #   enable = true;
    # };

    # codex = {
    #   enable = true;
    # };

    # gh = {
    #   enable = true;
    # };

    # nix-index.enable = true;

  };

  services = {
    ollama.enable = true;
  };
}
