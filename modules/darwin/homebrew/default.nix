# Main Homebrew configuration module
{
  imports = [
    ./taps.nix
    ./brews.nix
    ./casks.nix
  ];

  homebrew = {
    enable = true;

    # Update and upgrade packages on activation
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    # Mac App Store apps (currently empty)
    masApps = {
      # Example: "Toggl" = 1291898086;
    };
  };
}