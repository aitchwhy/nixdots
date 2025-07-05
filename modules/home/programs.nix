{ pkgs, ... }:
{
  # Programs natively supported by home-manager
  # They can be configured in `programs.*` instead of using home.packages
  programs = {
    # Better `cat`
    bat.enable = true;
    jq.enable = true;

    # System monitoring
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
      };
    };

    # Terminal sharing
    # tmate = {
    #   enable = true;
    #   # host = ""; # In case you wish to use a server other than tmate.io
    # };

    # Git UI tools
    lazygit.enable = true;
    lazydocker.enable = true;

    # System info
    fastfetch.enable = true;
  };
}
