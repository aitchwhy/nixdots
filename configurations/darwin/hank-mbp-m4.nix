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

  # Create kanata configuration file
  environment.etc."kanata/config.kbd".text = ''
    ;; Define configuration options
    (defcfg
      ;; For macOS
      process-unmapped-keys yes
    )

    ;; Define the source layer (your physical keyboard)
    (defsrc
      esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
      grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
      tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
      caps a    s    d    f    g    h    j    k    l    ;    '    ret
      lsft z    x    c    v    b    n    m    ,    .    /    rsft
      lctl lopt lcmd           spc            rcmd ropt rctl
    )

    ;; Define the base layer with capslock remapped
    (deflayer base
      _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _    _    _
      @cap _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _    _    _    _    _    _    _    _    _    _
      _    _    _              _              _    _    _
    )

    ;; Define the tap-hold behavior for capslock
    (defalias
      ;; caps lock → ESC on tap, left cmd+option+ctrl on hold
      cap (tap-hold 200 esc (multi lctl lopt lcmd))
    )
  '';

  # Set up launchd agent for kanata
  launchd.user.agents.kanata = {
    command = "/opt/homebrew/bin/kanata -c /etc/kanata/config.kbd";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/kanata.out.log";
      StandardErrorPath = "/tmp/kanata.err.log";
    };
  };

  homebrew = {
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
      # "aider"                       # AI coding assistant
      "7zip"
      "atuin"
      "awscli"
      "bat"                         # Better cat
      "bitwarden-cli"
      # "bruno-cli"                   # Git-friendly API client
      "bun"                         # JS runtime
      # "caddy"                       # HTTP server w/ HTTPS
      # "coder"
      # "commitizen"
      "coreutils"
      "curl"                        # HTTP client
      # "datasette"                   # SQLite explorer
      "direnv"                      # Per-dir env vars
      # "dive"                        # Docker layer explorer
      # "dotenvx/brew/dotenvx"
      # "dprint"
      "dust"                        # Disk usage
      # "e2b"
      "editorconfig"
      # "entr"                        # File watcher
      # "eslint"
      "eza"                         # Better ls
      # "f2"
      "fd"                          # Better find
      "fastfetch"                   # System info
      # "ffmpeg"
      "flyctl"
      "fzf"
      "fx"                          # JSON viewer
      "gdrive"
      "gh"                          # GitHub CLI
      # "ghc"
      "git"
      "git-extras"                  # small git utils (git-ignore, git-standup, git-sync)
      # "git-filter-repo"
      "git-delta"                   # Better git diffs
      # "git-lfs"
      # "gitleaks"                    # Secret scanner
      # "glow"                        # Markdown viewer
      "go"                          # Go language
      # "goaccess"                    # Web log analyser
      # "hexyl"
      "htop"
      # "httpie"
      # "hurl"                        # HTTP testing
      # "imagemagick"
      # "jo"                          # JSON generator
      "jq"
      # "jtbl"                        # JSON → tables
      # "just"                        # Command runner
      "kanata"                      # Keyboard remapper
      # "kiota"                       # HTTP client generator
      "koekeishiya/formulae/skhd"   # Hotkey daemon
      # "lazydocker"
      # "lazygit"
      # "lefthook"                    # Git hooks
      # "lnav"
      # "luarocks"
      # "mas"                         # Mac App Store CLI
      # "miller"                      # CSV swiss-army-knife
      "neovim"
      "nixpacks"
      # "nvm"
      # "nx"
      # "openapi-tui"                 # OpenAPI TUI
      # "ouch"
      # "p7zip"
      # "pandoc"
      # "pgcli"
      # "podman"
      # "poppler"
      "postgresql@17"
      # "prettier"
      # "prism-cli"                   # API mocking / contract
      "procs"                       # Better ps
      # "pulumi/tap/pulumi"
      "ripgrep"
      # "resvg"
      # "rich"
      "ruby"
      "rustscan"
      # "rustup-init"
      "sd"                          # Better sed
      "semgrep"                     # Static analysis
      "shellcheck"
      "shfmt"
      # "siderolabs/tap/talosctl"
      "skopeo"
      "sops"
      # "spectral-cli"                # OpenAPI linter
      "speedtest-cli"
      # "spider-cloud-cli"
      "starship"                    # Prompt
      # "supabase/tap/supabase"
      # "tag"
      # "taplo"
      # "tectonic"
      "terraform"
      # "tesseract"
      "tlrc"                        # tldr client
      "tmux"
      # "trivy"
      # "trufflehog"
      "uv"
      # "vite"
      "wget"
      # "xh"                          # Modern HTTP client
      "xo/xo/usql"
      "yq"
      # "yazi"
      "zellij"
      "zoxide"
      "zsh-autosuggestions"
      "zsh-completions"
      "zsh-syntax-highlighting"
    ];

    casks =
      [
        # "a-better-finder-rename"
        # "airtable"
        # "anki"
        # "another-redis-desktop-manager"
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
        "ghostty"
        "google-chrome"
        # "google-drive"
        "hammerspoon"
        "hazel"
        "homerow"
        # "iina"
        "imageoptim"
        "istat-menus"
        # "jump"
        "jump-desktop-connect"
        "kaleidoscope"
        # "karabiner-elements"
        "keka"
        "kekaexternalhelper"
        "linear-linear"
        "lm-studio"
        # "maccy"
        "macwhisper"
        # "mitmproxy"
        # "ngrok"
        "nikitabobko/tap/aerospace"
        # "nosql-workbench"
        # "notion"
        "obsidian"
        "ollama"
        "onlook"
        "orbstack"
        # "osquery"
        # "pdf-expert"
        "postman"
        # "prism"
        # "prisma-studio"
        "proxyman"
        # "qlcolorcode"
        "qlmarkdown"
        # "qlstephen"
        "quicklook-json"
        "raycast"
        # "repo-prompt"
        # "rize"
        # "royal-tsx"
        "signal"
        "slack"
        "spotify"
        "superhuman"
        # "superwhisper"
        # "swish"
        # "syncthing"
        # "syntax-highlight"
        # "tableplus"
        "tailscale"
        # "timelane"
        # "tla+-toolbox"
        "todoist"
        # "virtualbuddy"
        # "visual-studio-code"
        "warp"
        # "wireshark"
        # "zed"
        # "zen"
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
