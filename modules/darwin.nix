# macOS (Darwin) system configuration
# This file contains:
# - System-level packages (only essential OS utilities)
# - macOS system preferences and defaults
# - System services configuration
{ pkgs, ... }:
{
  # Use TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # System packages - only essential system-level tools
  environment.systemPackages = with pkgs; [
    # Core system utilities
    coreutils
    gnumake
    git

    # macOS specific system tools
    darwin.trash
    mas # Mac App Store CLI
  ];

  # macOS system settings
  system = {
    primaryUser = "hank";

    defaults = {
      # Dock
      dock = {
        orientation = "bottom";
        show-process-indicators = true;
        show-recents = false;
        static-only = false;
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.2;
        expose-animation-duration = 0.1;
        tilesize = 48;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
        enable-spring-load-actions-on-all-items = true;

        # Hot corners
        wvous-tl-corner = 2; # top-left - Mission Control
        wvous-tr-corner = 12; # top-right - Notification Center
        wvous-bl-corner = 3; # bottom-left - Application Windows
        wvous-br-corner = 4; # bottom-right - Desktop
      };

      # Finder
      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
        FXDefaultSearchScope = "SCcf"; # Search current folder
        FXPreferredViewStyle = "clmv"; # Column view
        NewWindowTarget = "Home";
        NewWindowTargetPath = "file://$HOME/";
      };

      # Trackpad
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
        Dragging = false;
        DragLock = false;
      };

      # Global macOS settings
      NSGlobalDomain = {
        # UI/UX
        "com.apple.swipescrolldirection" = true;
        "com.apple.sound.beep.feedback" = 0;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        AppleShowScrollBars = "Always";

        # Keyboard
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticTextCompletionEnabled = false;

        # Performance
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowResizeTime = 0.001;
        NSWindowShouldDragOnGesture = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
        NSDocumentSaveNewDocumentsToCloud = false;

        # Developer
        NSTextShowsControlCharacters = true;
        WebKitDeveloperExtras = true;
      };

      # Custom preferences
      CustomUserPreferences = {
        ".GlobalPreferences" = {
          AppleSpacesSwitchOnActivate = true;
          WebAutomaticTextReplacementEnabled = false;
          WebContinuousSpellCheckingEnabled = false;
          WebAutomaticSpellingCorrectionEnabled = false;
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
          FXDefaultSearchScope = "SCcf";
          FXPreferredViewStyle = "clmv";
        };

        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };

        "com.apple.spaces" = {
          "spans-displays" = 0;
          "mru-spaces" = false;
        };

        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0;
          StandardHideDesktopIcons = 0;
          HideDesktop = 0;
          StageManagerHideWidgets = 0;
          StandardHideWidgets = 0;
          GloballyEnabled = false;
        };

        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 0;
        };

        "com.apple.screencapture" = {
          location = "~/Desktop/Screenshots";
          type = "png";
          disable-shadow = true;
          include-date = true;
        };

        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };

        "com.apple.ImageCapture".disableHotPlug = true;

        # Safari Developer Settings
        "com.apple.Safari" = {
          IncludeInternalDebugMenu = true;
          IncludeDevelopMenu = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          AutoOpenSafeDownloads = false;
          ShowFavoritesBar = false;
          ShowSidebarInTopSites = false;
          ShowFullURLInSmartSearchField = true;
        };

        # Terminal
        "com.apple.terminal" = {
          SecureKeyboardEntry = true;
          ShowLineMarks = false;
        };

        # Activity Monitor
        "com.apple.ActivityMonitor" = {
          OpenMainWindow = true;
          IconType = 5;
          ShowCategory = 0;
          SortColumn = "CPUUsage";
          SortDirection = 0;
        };

        # Xcode
        "com.apple.dt.Xcode" = {
          DVTTextShowLineNumbers = true;
          DVTTextShowPageGuide = true;
          DVTTextPageGuideLocation = 120;
          DVTTextShowFoldingSidebar = true;
          DVTTextIndentUsingSpaces = true;
          DVTTextIndentWidth = 2;
          DVTTextTabWidth = 2;
        };
      };

      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true;
        LoginwindowText = "";
        DisableConsoleAccess = true;
      };

      # Additional settings
      menuExtraClock = {
        IsAnalog = false;
        Show24Hour = true;
        ShowAMPM = false;
        ShowDate = 1; # Show date always
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
      };

      # Disable quarantine for downloaded apps
      LaunchServices.LSQuarantine = false;
    };

    # Keyboard customization
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  # Additional system configurations
  system.startup.chime = false;
}
