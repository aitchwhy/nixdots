# Homebrew configuration for macOS
{
  homebrew = {
    enable = true;
    
    # Update and upgrade on activation
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    
    # Taps
    taps = [
      "derailed/k9s"
      "helix-editor/helix"
      "homebrew/services"
      "jesseduffield/lazygit"
      "pulumi/tap"
      "supabase/tap"
      "tursodatabase/tap"
    ];
    
    # Formulae (CLI tools)
    brews = [
      "blueutil"
      "chrome-cli"
      "fswatch"
      "lima"
      "turso"
    ];
    
    # Casks (GUI applications)
    casks = [
      # Browsers
      "arc"
      "brave-browser"
      "google-chrome"
      
      # Development
      "cursor"
      "dash"
      "docker"
      "figma"
      "github"
      "gpg-suite"
      "iterm2"
      "linear-linear"
      "ngrok"
      "orbstack"
      "postman"
      "proxyman"
      "raycast"
      "rectangle"
      "sequel-ace"
      "sublime-text"
      "tableplus"
      "visual-studio-code"
      "warp"
      "xcodes"
      "zed"
      
      # Productivity
      "camo"
      "cleanmymac"
      "craft"
      "fantastical"
      "grammarly-desktop"
      "notion"
      "obsidian"
      "omnifocus"
      "readdle-spark"
      "setapp"
      "todoist"
      
      # Media
      "calibre"
      "elpass"
      "handbrake"
      "iina"
      "imageoptim"
      "itsycal"
      "keka"
      "kindle"
      "loom"
      "pdf-expert"
      "plex"
      "spotify"
      "transmission"
      "vlc"
      
      # Communication
      "discord"
      "keybase"
      "mimestream"
      "signal"
      "slack"
      "telegram"
      "whatsapp"
      "zoom"
      
      # System utilities
      "appcleaner"
      "apparency"
      "bartender"
      "daisydisk"
      "little-snitch"
      "stats"
      "tailscale"
      
      # Other
      "perplexity"
    ];
    
    # Mac App Store apps
    masApps = {
      # Add any Mac App Store apps here
      # "App Name" = app_id;
    };
  };
}