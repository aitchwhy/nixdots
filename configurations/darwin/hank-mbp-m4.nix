# See /modules/darwin/* for actual settings
# This file is just *top-level* configuration.
{ flake, lib, pkgs, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    self.darwinModules.default
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  networking.hostName = "hank-mbp-m4";

  system.primaryUser = "hank";

  # Automatically move old dotfiles out of the way
  #
  # Note that home-manager is not very smart, if this backup file already exists it
  # will complain "Existing file .. would be clobbered by backing up". To mitigate this,
  # we try to use as unique a backup file extension as possible.
  home-manager.backupFileExtension = "nixos-unified-template-backup";
    services = {
    tailscale.enable = true;
  };





  homebrew ={
    enable = true;

    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    taps = [
      "dotenvx/brew"
      "f1bonacc1/tap"
      "koekeishiya/formulae"
      "nikitabobko/tap"
      "pulumi/tap"
    ];

    brews = [
      # macOS specific tools that need Homebrew
      "kanata"                      # Keyboard remapper (macOS specific build)
      "koekeishiya/formulae/skhd"   # Hotkey daemon (macOS specific)

      # Packages from specific taps not in nixpkgs
      "dotenvx/brew/dotenvx"        # From specific tap
      "xo/xo/usql"                  # From specific tap
      "supabase/tap/supabase"       # From specific tap
      "spider-cloud-cli"            # Not in nixpkgs
      "prism-cli"                   # API mocking / contract - not in nixpkgs
      "gdrive"                      # Google Drive CLI - not in nixpkgs
      "bruno-cli"                   # Git-friendly API client - not in nixpkgs
      "f2"                          # Not in nixpkgs
      "jtbl"                        # JSON → tables - not in nixpkgs
      "resvg"                       # Not in nixpkgs
      "tectonic"                    # Not in nixpkgs
      "vite"                        # Not in nixpkgs
      "nx"                          # Not in nixpkgs
      "coder"                       # Not in nixpkgs
      "trufflehog"                  # Not in nixpkgs
      "slack"
      "claude-squad"
    ];

    casks =
      [
        "a-better-finder-rename"
        "airtable"
        "anki"
        "another-redis-desktop-manager"
        # "asana"
        # "audacity"
        "bartender"
        # "betterdisplay"
        "bitwarden"
        # "bruno"
        # "bunch"
        # "canva"
        "carbon-copy-cloner"
        "cardhop"
        "chatgpt"
        "claude"
        "cleanshot"
        "codeql"
        # "coq-platform"
        "cursor"
        # "dadroit-json-viewer"
        # "daisydisk"
        "dash"
        # "descript"
        "devutils"
        # "draw-things"
        # "espanso"
        # "excalidrawz"
        "fantastical"
        # "figma"
        "folo" # follow RSS feed reader app
        "fork"
        "font-fira-code-nerd-font"
        "font-fira-mono-nerd-font"
        "font-symbols-only-nerd-font"
        # "ghidra"
        # "ghostty"
        "google-chrome"
        # "google-drive"
        "hammerspoon"
        "hazel"
        "homerow"
        # "iina"
        "imageoptim"
        "istat-menus"
        "jump"
        "jump-desktop-connect"
        "kaleidoscope"
        "karabiner-elements"
        "keka"
        "kekaexternalhelper"
        "linear-linear"
        "lm-studio"
        # "maccy"
        "macwhisper"
        "mitmproxy"
        "ngrok"
        "nikitabobko/tap/aerospace"
        "nosql-workbench"
        "notion"
        "obsidian"
        "ollama"
        "onlook"
        "orbstack"
        # "osquery"
        "pdf-expert"
        "postman"
        # "prism"
        # "prisma-studio"
        "proxyman"
        "qlcolorcode"
        "qlmarkdown"
        "qlstephen"
        "quicklook-json"
        "raycast"
        # "repo-prompt"
        "rize"
        "royal-tsx"
        "signal"
        "slack"
        "spotify"
        "superhuman"
        "superwhisper"
        "swish"
        # "syncthing"
        "syntax-highlight"
        "tableplus"
        "tailscale"
        # "timelane"
        # "tla+-toolbox"
        "todoist"
        "virtualbuddy"
        # "visual-studio-code"
        "warp"
        # "wireshark"
        "zed"
        "zen"
        "zoom"
      ];


    masApps = {
      # "Toggl" = 1291898086;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
