# macOS (Darwin) system configuration
{ pkgs, ... }:
{
  # Import shared defaults
  imports = [ ./shared/defaults.nix ];

  # Use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Essential system tools
    coreutils
    gnumake
    git
    just
    
    # Terminal emulators
    warp-terminal
    
    # macOS specific
    darwin.trash
  ];

  # macOS system settings
  system = {
    primaryUser = "hank";
    
    defaults = {
      # Dock
      dock = {
        orientation = "bottom";
        show-process-indicators = false;
        show-recents = false;
        static-only = true;
        # Hot corners
        wvous-tl-corner = 2; # top-left - Mission Control
        wvous-bl-corner = 3; # bottom-left - Application Windows
        wvous-br-corner = 4; # bottom-right - Desktop
      };

      # Finder
      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXDefaultSearchScope = "SCcf";
      };

      # Trackpad
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      # Global macOS settings
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        "com.apple.sound.beep.feedback" = 0;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowShouldDragOnGesture = true;
      };

      # Custom preferences
      CustomUserPreferences = {
        ".GlobalPreferences" = {
          AppleSpacesSwitchOnActivate = true;
        };
        
        NSGlobalDomain = {
          WebKitDeveloperExtras = true;
        };
        
        "com.apple.finder" = {
          AppleShowAllFiles = true;
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
        };
        
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        
        "com.apple.spaces" = {
          "spans-displays" = 0;
        };
        
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0;
          StandardHideDesktopIcons = 0;
          HideDesktop = 0;
          StageManagerHideWidgets = 0;
          StandardHideWidgets = 0;
        };
        
        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        
        "com.apple.ImageCapture".disableHotPlug = true;
      };

      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true;
      };
    };
  };
}