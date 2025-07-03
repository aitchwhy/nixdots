# Nix Darwin Reorganization Plan

Based on Mitchell Hashimoto's nixos-config structure, here's a proposed reorganization:

## Current Structure
```
nixdots/
├── configurations/     # Old structure (to remove)
├── features/          # Core features (nix, shell, users)
├── hosts/            # Host-specific configs
├── homes/            # User home configs
├── lib/              # Helper functions
├── modules/          # Mixed darwin/nixos/home modules
└── packages/         # Empty, unused
```

## Proposed Structure (Inspired by mitchellh/nixos-config)
```
nixdots/
├── flake.nix         # Entry point
├── justfile          # Commands
├── lib/              # Shared functions and helpers
├── machines/         # Host configurations (rename from hosts)
│   └── hank-mbp-m4/
│       └── default.nix
├── modules/          # Reusable system modules
│   ├── darwin/       # Darwin-specific modules
│   ├── nixos/        # NixOS-specific modules
│   └── shared/       # Cross-platform modules
├── overlays/         # Package overlays
├── pkgs/            # Custom packages
├── users/           # User configurations (rename from homes)
│   └── hank/
│       ├── default.nix
│       └── packages/
└── tests/           # Test suite
```

## Key Improvements

1. **Clear Separation**
   - `machines/` for hardware-specific configs
   - `users/` for user-specific configs
   - `modules/` for reusable components

2. **Better Module Organization**
   - Separate darwin/nixos/shared modules
   - Each module self-contained with clear purpose

3. **Package Management**
   - `overlays/` for modifying existing packages
   - `pkgs/` for custom package definitions
   - User-specific packages in `users/<name>/packages/`

4. **Simplified Imports**
   - Each directory has clear purpose
   - No mixing of concerns
   - Easy to find configurations

## Migration Steps

1. Rename directories:
   - `hosts/` → `machines/`
   - `homes/` → `users/`
   - Remove `configurations/` (already migrated)

2. Reorganize modules:
   - Keep platform separation clear
   - Move shared code to `modules/shared/`

3. Add overlays directory for package customizations

4. Update flake.nix and lib/mkSystem.nix to use new paths

## Benefits

- **Clarity**: Each directory has single, clear purpose
- **Scalability**: Easy to add new machines/users
- **Maintainability**: Clear separation of concerns
- **Flexibility**: Platform-specific and shared modules