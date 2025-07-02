{ config, pkgs, lib, ... }:
{
  networking.hostName = "hank-mbp-m4";
  system.stateVersion = 4;
  
  # PostgreSQL service configuration
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_17;
    dataDir = "/usr/local/var/postgres";
    enableTCPIP = true;
    authentication = ''
      local all all trust
      host all all 127.0.0.1/32 trust
    '';
  };
  
  # Tailscale
  services.tailscale.enable = true;
  
  # macOS system defaults
  system.defaults = {
    dock = {
      # autohide = true;
      # customize Hot Corners
      wvous-tl-corner = 2; # top-left - Mission Control
      # wvous-tr-corner = 13; # top-right - Lock Screen
      wvous-bl-corner = 3; # bottom-left - Application Windows
      wvous-br-corner = 4; # bottom-right - Desktop
      orientation = "bottom";
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };

    finder = {
      _FXShowPosixPathInTitle = true; # show full path in finder title
      AppleShowAllExtensions = true; # show all file extensions
      FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
      QuitMenuItem = true; # enable quit menu item
      ShowPathbar = true; # show path bar
      ShowStatusBar = true; # show status bar
      FXDefaultSearchScope = "SCcf";
    };

    # customize trackpad
    trackpad = {
      Clicking = true;  # enable tap to click
      TrackpadRightClick = true;  # enable two finger right click
      TrackpadThreeFingerDrag = true;  # enable three finger drag
    };

    # customize settings that not supported by nix-darwin directly
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = true;  # enable natural scrolling
      "com.apple.sound.beep.feedback" = 0;  # disable beep sound when pressing volume up/down key
      AppleInterfaceStyle = "Dark";  # dark mode
      AppleKeyboardUIMode = 3;  # Mode 3 enables full keyboard control.
      ApplePressAndHoldEnabled = false;  # disable press and hold

      # Keyboard repeat settings
      InitialKeyRepeat = 15;  # normal minimum is 15 (225 ms)
      KeyRepeat = 3;  # normal minimum is 2 (30 ms)

      "com.apple.keyboard.fnState" = true;
      NSAutomaticWindowAnimationsEnabled = false;
      NSWindowShouldDragOnGesture = true;
    };

    # Custom user preferences
    CustomUserPreferences = {
      ".GlobalPreferences" = {
        # automatically switch to a new space when switching to the application
        AppleSpacesSwitchOnActivate = true;
      };
      NSGlobalDomain = {
        # Add a context menu item for showing the Web Inspector in web views
        WebKitDeveloperExtras = true;
        # set fn keys to default to f1~f12
        "com.apple.keyboard.fnState" = false;
      };
      "com.apple.finder" = {
        AppleShowAllFiles = true;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.spaces" = {
        "spans-displays" = 0; # Display have seperate spaces
      };
      "com.apple.WindowManager" = {
        EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
        StandardHideDesktopIcons = 0; # Show items on desktop
        HideDesktop = 0; # Do not hide items on desktop & stage manager
        StageManagerHideWidgets = 0;
        StandardHideWidgets = 0;
      };
      "com.apple.screensaver" = {
        # Require password immediately after sleep or screen saver begins
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
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
    };

    loginwindow = {
      GuestEnabled = false;  # disable guest user
      SHOWFULLNAME = true;  # show full name in login window
    };
  };
  
  # Backup file extension for home-manager
  home-manager.backupFileExtension = "nixos-unified-template-backup";
}