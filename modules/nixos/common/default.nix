# Darwin common defaults
{ config, lib, pkgs, ... }:
{
  # macOS system defaults
  system.defaults = {
    NSGlobalDomain = {
      # UI/UX
      AppleShowAllExtensions = lib.mkDefault true;
      AppleShowScrollBars = lib.mkDefault "WhenScrolling";
      NSTableViewDefaultSizeMode = lib.mkDefault 2;
      NSWindowResizeTime = lib.mkDefault 0.001;
      
      # Keyboard
      InitialKeyRepeat = lib.mkDefault 15;
      KeyRepeat = lib.mkDefault 2;
      ApplePressAndHoldEnabled = lib.mkDefault false;
      
      # Text
      NSAutomaticCapitalizationEnabled = lib.mkDefault false;
      NSAutomaticPeriodSubstitutionEnabled = lib.mkDefault false;
      NSAutomaticQuoteSubstitutionEnabled = lib.mkDefault false;
      NSAutomaticSpellingCorrectionEnabled = lib.mkDefault false;
      NSAutomaticTextCompletionEnabled = lib.mkDefault false;
      
      # Sound
      com.apple.sound.beep.feedback = lib.mkDefault 0;
      com.apple.sound.beep.volume = lib.mkDefault 0.0;
    };
    
    dock = {
      autohide = lib.mkDefault true;
      autohide-delay = lib.mkDefault 0.0;
      autohide-time-modifier = lib.mkDefault 0.5;
      launchanim = lib.mkDefault false;
      minimize-to-application = lib.mkDefault true;
      show-recents = lib.mkDefault false;
      static-only = lib.mkDefault false;
      tilesize = lib.mkDefault 48;
    };
    
    finder = {
      AppleShowAllExtensions = lib.mkDefault true;
      ShowPathbar = lib.mkDefault true;
      ShowStatusBar = lib.mkDefault true;
      FXEnableExtensionChangeWarning = lib.mkDefault false;
      _FXSortFoldersFirst = lib.mkDefault true;
    };
    
    trackpad = {
      Clicking = lib.mkDefault true;
      TrackpadRightClick = lib.mkDefault true;
      TrackpadThreeFingerDrag = lib.mkDefault true;
    };
    
    # Login window settings
    loginwindow = {
      GuestEnabled = lib.mkDefault false;
      DisableConsoleAccess = lib.mkDefault true;
    };
  };
  
  # Security settings
  security = {
    pam.enableSudoTouchIdAuth = lib.mkDefault true;
  };
  
  # Services
  services = {
    # Nix daemon is required for multi-user installs
    nix-daemon.enable = lib.mkDefault true;
  };
  
  # macOS-specific environment
  environment = {
    # Use native macOS tools when available
    systemPath = lib.mkDefault [
      "/usr/local/bin"
      "/usr/bin"
      "/usr/sbin"
      "/bin"
      "/sbin"
    ];
    
    # macOS-friendly shell configuration
    loginShell = lib.mkDefault pkgs.zsh;
  };
}