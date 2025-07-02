{ config, lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  homebrew = {
    enable = true;
    
    # Update and upgrade packages on activation
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    
    # Repository taps
    taps = [
      # Third-party repositories
      "dotenvx/brew"           # dotenvx environment tool
      "f1bonacc1/tap"         # process-compose and other tools
      "koekeishiya/formulae"  # skhd and yabai
      "nikitabobko/tap"       # aerospace window manager
      "pulumi/tap"            # pulumi infrastructure
      "supabase/tap"          # supabase CLI
      "xo/xo"                 # usql universal database client
    ];
    
    # CLI packages (formulae)
    brews = [
      # macOS-specific tools that need native Homebrew builds
      "kanata"                      # Keyboard remapper
      "koekeishiya/formulae/skhd"   # Hotkey daemon

      # Packages from specific taps
      "dotenvx/brew/dotenvx"        # Environment management
      "xo/xo/usql"                  # Universal SQL client
      "supabase/tap/supabase"       # Supabase CLI

      # Tools not available in nixpkgs
      "spider-cloud-cli"            # Spider web scraping
      "prism-cli"                   # API mocking / contract testing
      "gdrive"                      # Google Drive CLI
      "bruno-cli"                   # Git-friendly API client
      "f2"                          # Batch file renaming
      "jtbl"                        # JSON to tables converter
      "resvg"                       # SVG rendering
      "tectonic"                    # Modern TeX engine
      "vite"                        # Frontend build tool
      "nx"                          # Monorepo build system
      "coder"                       # Remote development
      "trufflehog"                  # Secret scanning
      "slack"                       # Slack CLI
      "claude-squad"                # Claude development tool
    ];
    
    # GUI applications (casks)
    casks = [
      # Productivity and utilities
      "a-better-finder-rename"      # Batch file renaming
      "bartender"                   # Menu bar management
      "hazel"                       # Automated organization
      "hammerspoon"                 # macOS automation
      "homerow"                     # Keyboard navigation
      "karabiner-elements"          # Keyboard customization
      "nikitabobko/tap/aerospace"   # Window management
      "raycast"                     # Productivity launcher
      "swish"                       # Window gestures

      # Development tools
      "cursor"                      # AI-powered editor
      "fork"                        # Git GUI
      "dash"                        # API documentation
      "tableplus"                   # Database GUI
      "proxyman"                    # HTTP debugging
      "mitmproxy"                   # HTTP proxy
      "ngrok"                       # Localhost tunneling
      "orbstack"                    # Docker/OrbStack
      "codeql"                      # Code analysis
      "devutils"                    # Developer utilities
      "nosql-workbench"             # NoSQL GUI

      # Communication
      "slack"                       # Team chat
      "signal"                      # Secure messaging
      "superhuman"                  # Email client
      "zoom"                        # Video conferencing

      # Note-taking and productivity
      "notion"                      # All-in-one workspace
      "obsidian"                    # Knowledge base
      "linear-linear"               # Project management
      "todoist"                     # Task management
      "fantastical"                 # Calendar
      "cardhop"                     # Contacts

      # AI and machine learning
      "chatgpt"                     # OpenAI ChatGPT
      "claude"                      # Anthropic Claude
      "lm-studio"                   # Local LLMs
      "ollama"                      # Local LLM runner
      "macwhisper"                  # Speech to text
      "superwhisper"                # Advanced transcription

      # Media and design
      "cleanshot"                   # Screenshot tool
      "imageoptim"                  # Image optimization
      "pdf-expert"                  # PDF editor
      "airtable"                    # Spreadsheet database
      "anki"                        # Flashcards
      "spotify"                     # Music streaming

      # System utilities
      "carbon-copy-cloner"          # Backup utility
      "istat-menus"                 # System monitoring
      "keka"                        # Archive utility
      "kekaexternalhelper"          # Keka helper
      "tailscale"                   # VPN/mesh network
      "bitwarden"                   # Password manager
      "virtualbuddy"                # macOS virtualization

      # Terminal and shells
      "warp"                        # Modern terminal

      # Remote access
      "jump"                        # Remote desktop
      "jump-desktop-connect"        # Jump connector
      "royal-tsx"                   # Remote management

      # Developer tools
      "another-redis-desktop-manager"  # Redis GUI
      "kaleidoscope"                # Diff tool
      "postman"                     # API testing
      "onlook"                      # Visual web editor
      
      # Browsers
      "google-chrome"               # Web browser
      "zed"                         # Code editor
      "zen"                         # Browser

      # Fonts
      "font-fira-code-nerd-font"
      "font-fira-mono-nerd-font"
      "font-symbols-only-nerd-font"

      # QuickLook plugins
      "qlcolorcode"                 # Syntax highlighting
      "qlmarkdown"                  # Markdown preview
      "qlstephen"                   # Plain text preview
      "quicklook-json"              # JSON preview
      "syntax-highlight"            # Code highlighting

      # RSS and reading
      "folo"                        # RSS feed reader
      "rize"                        # Time tracking
    ];
    
    # Mac App Store apps (currently empty)
    masApps = {
      # Example: "Toggl" = 1291898086;
    };
  };
}