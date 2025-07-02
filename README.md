# Hank's Nix Configuration

A clean, cross-platform Nix configuration for macOS and Linux systems.

## Structure

```
.
├── flake.nix          # Entry point defining systems
├── lib/               # Helper functions for building systems
├── features/          # Cross-cutting system features
│   ├── nix.nix       # Nix daemon configuration
│   ├── shell.nix     # Shell environment and packages
│   ├── users.nix     # User account management
│   └── homebrew.nix  # macOS Homebrew packages
├── homes/            # User home-manager configurations
│   └── hank.nix     # Personal dotfiles and packages
└── hosts/            # Host-specific configurations
    └── hank-mbp-m4.nix # MacBook Pro M4 settings
```

## Design Principles

1. **Cross-Cutting Concerns**: Features that affect multiple aspects (system, home, platform) live in single modules
2. **Explicit Configuration**: No hidden imports or auto-loading magic
3. **Platform-Aware**: Single modules gracefully handle macOS/Linux differences
4. **Minimal Host Config**: Host files only contain truly host-specific settings
5. **Performance**: Shared nixpkgs instance, minimal module evaluations

## Quick Start

### Prerequisites

- Nix with flakes enabled
- For macOS: [nix-darwin](https://github.com/LnL7/nix-darwin)

### Installation

1. Clone this repository:

   ```bash
   git clone <repository-url> ~/nixdots
   cd ~/nixdots
   ```

2. Build and switch to the configuration:

   ```bash
   # For macOS
   darwin-rebuild switch --flake .#hank-mbp-m4

   # Or use just
   just switch
   ```

## Common Tasks

```bash
# Update all flake inputs
just update

# Format nix files
just fmt

# Check configuration
just check

# Build without switching
just build

# Clean old generations
just clean

# Enter development shell
just dev
```

## Adding New Configurations

### New Host

1. Create `hosts/hostname.nix` with host-specific settings
2. Add to `flake.nix`:

   ```nix
   darwinConfigurations.hostname = lib.mkSystem.mkDarwin {
     hostname = "hostname";
     system = "aarch64-darwin"; # or x86_64-linux
     users = {
       username = import ./homes/username.nix;
     };
   };
   ```

### New User

1. Create `homes/username.nix` with home-manager configuration
2. Reference in host configuration's `users` attribute

### New Feature

1. Create `features/feature.nix` as a cross-cutting module
2. Add to `lib/mkSystem.nix` modules list
3. Use `lib.mkIf` for platform-specific behavior

## Key Features

- **Development Environment**: Comprehensive set of modern CLI tools
- **macOS Integration**: Homebrew casks and brews, system defaults
- **Shell Experience**: Zsh with autosuggestions, starship prompt, modern replacements for Unix tools
- **Git Workflow**: Preconfigured git, lazygit, delta diff viewer
- **Nix Tooling**: nixd LSP, nix-index, formatting and linting

## Platform Support

- ✅ macOS (Apple Silicon)
- ✅ macOS (Intel)
- 🚧 Linux (prepared but not actively used)
- 🚧 WSL (can be added to feature modules)

## Credits

Inspired by:

- [Mitchell Hashimoto's nixos-config](https://github.com/mitchellh/nixos-config)
- The Dendritic Pattern community
- [nixos-unified](https://github.com/srid/nixos-unified) template (previous structure)

## License

MIT
