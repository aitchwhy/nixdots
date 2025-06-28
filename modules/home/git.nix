{ config, ... }:
{

  # https://nixos.asia/en/git
  programs = {
    git = {
      enable = true;
      userName = config.me.fullname;
      userEmail = config.me.email;
      ignores = [
        "*~"
        "*.swp"
        ".DS_Store"
        "node_modules"
        "dist"
        "build"
        "out"
        "target"
        "tmp"
        ".env"
        ".env.local"
        ".DS_Store"
      ];
      aliases = {
        b = "branch";
        c = "commit";
        co = "checkout";
        d = "diff";
        l = "log";
        ll = "pull";
        p = "push";
        s = "status";
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      delta.enable = true;
      lfs.enable = true;
    };

    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    lazygit = {
      enable = true;
      settings.diff.context = 10;
    };

  };

}
