# Sensible defaults for home-manager
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Home-manager settings
  programs.home-manager.enable = lib.mkDefault true;

  # Basic program defaults
  programs = {
    # Git defaults
    git = {
      enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      extraConfig = {
        init.defaultBranch = lib.mkDefault "main";
        push.autoSetupRemote = lib.mkDefault true;
        pull.rebase = lib.mkDefault true;
        rerere.enabled = lib.mkDefault true;
        fetch.prune = lib.mkDefault true;
        diff.colorMoved = lib.mkDefault "zebra";
        merge.conflictStyle = lib.mkDefault "zdiff3";
      };
    };

    # Shell enhancements
    direnv = {
      enable = lib.mkDefault true;
      nix-direnv.enable = lib.mkDefault true;
    };

    starship = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      # settings = {

      # }
    };

    fzf = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      defaultOptions = lib.mkDefault [
        "--height 40%"
        "--border"
        "--preview-window=right:50%"
      ];
    };

    zoxide = {
      enable = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
    };

    # Terminal multiplexer
    tmux = {
      enable = lib.mkDefault true;
      baseIndex = lib.mkDefault 1;
      clock24 = lib.mkDefault true;
      escapeTime = lib.mkDefault 0;
      historyLimit = lib.mkDefault 10000;
      keyMode = lib.mkDefault "vi";
      mouse = lib.mkDefault true;
      terminal = lib.mkDefault "screen-256color";
    };
  };

  # XDG defaults
  xdg = {
    enable = lib.mkDefault true;
    configHome = lib.mkDefault "${config.home.homeDirectory}/.config";
    cacheHome = lib.mkDefault "${config.home.homeDirectory}/.cache";
    dataHome = lib.mkDefault "${config.home.homeDirectory}/.local/share";
    stateHome = lib.mkDefault "${config.home.homeDirectory}/.local/state";
  };

  # Font configuration
  fonts.fontconfig.enable = lib.mkDefault true;

  # News settings
  news = {
    display = lib.mkDefault "silent";
    json = lib.mkDefault { };
    entries = lib.mkDefault [ ];
  };
}
