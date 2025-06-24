{ ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "1440";
      style = "tokyo-night";
    };
  };
}
