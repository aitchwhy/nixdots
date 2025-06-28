# Homebrew CLI packages (formulae)
{
  homebrew.brews = [
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
}