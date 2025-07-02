# Migration Guide: Consolidating Nix Configuration

This guide documents the migration from the nixos-unified template structure to a simpler, cross-cutting concerns based architecture.

## Overview of Changes

### Old Structure

```
modules/
├── darwin/
│   ├── common/
│   ├── homebrew/
│   └── default.nix
├── home/
│   ├── [many individual modules]
│   └── packages/
├── nixos/
│   └── common/
├── shared/
└── flake/

configurations/
├── darwin/
└── home/
```

### New Structure

```
lib/                 # Shared utilities
features/            # Cross-cutting concerns
├── nix.nix         # Nix configuration (all platforms)
├── shell.nix       # Shell environment
├── users.nix       # User management
└── homebrew.nix    # macOS Homebrew

homes/              # User configurations
└── hank.nix       # All home-manager config in one file

hosts/              # Host configurations
└── hank-mbp-m4.nix # Minimal host-specific settings
```

## Key Design Improvements

1. **Cross-Cutting Concerns**: Features that span multiple module types are now in single files
2. **Explicit Imports**: No more auto-import magic with `default.nix` files
3. **Platform-Aware**: Single modules handle platform differences with `lib.mkIf`
4. **Consolidated Home Config**: All user configuration in one file per user
5. **Minimal Host Config**: Only host-specific settings, everything else in features

## Migration Steps

### 1. Backup Current Configuration

```bash
just backup-old
```

### 2. Test New Configuration

```bash
# Check the flake
nix flake check

# Build without switching
just build

# Review what will change
just dry-run
```

### 3. Apply New Configuration

```bash
just switch
```

### 4. Clean Up (After Verification)

```bash
# Remove old structure
just clean-old

# Commit changes
git add .
git commit -m "Migrate to consolidated nix configuration"
```

## Troubleshooting

### Common Issues

1. **Missing packages**: Check that all packages from the old structure are included in:
   - `features/shell.nix` for system packages
   - `homes/hank.nix` for user packages

2. **Platform-specific errors**: Ensure platform conditionals use:
   - `lib.mkIf pkgs.stdenv.isDarwin` for macOS-only
   - `lib.mkIf pkgs.stdenv.isLinux` for Linux-only

3. **Home-manager issues**: The new structure uses:
   - `useGlobalPkgs = true`
   - `useUserPackages = true`
   This shares the nixpkgs instance for better performance

## Benefits of New Structure

1. **Easier to understand**: Clear separation between features, users, and hosts
2. **Less duplication**: Platform differences handled in single modules
3. **Better performance**: Fewer module evaluations, shared nixpkgs instance
4. **Explicit dependencies**: No hidden imports or magic
5. **Easier maintenance**: Related configuration grouped together

## Adding New Features

To add a new cross-cutting feature:

1. Create `features/myfeature.nix`
2. Handle platform differences with `lib.mkIf`
3. Add to the modules list in `lib/mkSystem.nix`

Example:

```nix
{ config, lib, pkgs, ... }:
{
  # Common configuration
  services.myservice.enable = true;

  # Platform-specific
  environment.systemPackages = with pkgs; [
    common-package
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    darwin-only-package
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    linux-only-package
  ];
}
```

## Future Additions

The new structure makes it easy to add:

- Additional hosts: Create new files in `hosts/`
- Additional users: Create new files in `homes/`
- WSL support: Add WSL detection to feature modules
- NixOS support: Already prepared in `lib/mkSystem.nix`
