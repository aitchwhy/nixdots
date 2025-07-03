# Homebrew to Nix Migration Summary

## Changes Made

### 1. Removed Redundant File
- Deleted `/features/homebrew.nix` (was duplicate of modular structure)

### 2. Migrated Packages from Homebrew to Home-Manager

The following packages were moved from Homebrew's `brews.nix` to appropriate home-manager modules:

#### Development Tools (`modules/home/packages/development.nix`)
- `trufflehog` - Secret scanning
- `coder` - Remote development environments

#### Utilities (`modules/home/packages/utilities.nix`)
- `f2` - Batch file renaming

#### Data Tools (`modules/home/packages/data-tools.nix`)
- `jtbl` - JSON to tables converter

#### Media Apps (`modules/home/packages/media-apps.nix`)
- `resvg` - SVG rendering
- `tectonic` - Modern TeX engine

### 3. Packages Remaining in Homebrew

These packages remain in Homebrew as they're not available in nixpkgs:
- `vite` - Frontend build tool
- `nx` - Monorepo build system
- `spider-cloud-cli` - Spider web scraping
- `prism-cli` - API mocking / contract testing
- `gdrive` - Google Drive CLI
- `bruno-cli` - Git-friendly API client
- `slack` - Slack CLI
- `claude-squad` - Claude development tool

## Modern macOS M4 Best Practices (July 2025)

1. **Package Priority**: Prefer nixpkgs > Homebrew for better reproducibility
2. **GUI Apps**: Keep in Homebrew casks for macOS integration
3. **macOS-specific**: Keep tools like `kanata`, `skhd` in Homebrew
4. **Modular Structure**: Organize by category for maintainability

## To Apply Changes

```bash
# Rebuild your nix-darwin configuration
darwin-rebuild switch --flake .#hank-mbp-m4
```

## Next Steps

Consider reviewing:
1. Duplicate packages between home-manager and Homebrew
2. Additional casks that might be better as Nix packages
3. Setting up development shells with flake.nix for project-specific tools