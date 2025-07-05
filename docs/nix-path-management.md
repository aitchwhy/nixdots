# Nix Path Management Documentation

## Overview

This document explains the optimized dual-path setup for Nix binaries in the nixdots configuration, where both nix-darwin (system-level) and home-manager (user-level) work together without conflicts.

## Key Findings

### 1. **Expected Behavior**
- ✅ Both nix-darwin and home-manager can install Nix binaries
- ✅ The separation of concerns is intentional and recommended
- ✅ nix-darwin manages system-wide configurations
- ✅ home-manager handles user-specific settings

### 2. **Functional Design**
All paths ultimately resolve to the same Nix store location, preventing conflicts:
- `/run/current-system/sw/bin/nix` → `/nix/store/.../nix`
- `/etc/profiles/per-user/hank/bin/nix` → `/nix/store/.../nix`
- `~/.nix-profile/bin/nix` → `/nix/store/.../nix`

### 3. **Best Practices Implemented**

#### Single Source of Truth
- Nix package and core settings are managed exclusively in `features/nix.nix`
- Removed duplicate package management from home-manager
- Eliminated redundant settings in `modules/shared/defaults.nix`

#### Clear Separation of Concerns
- **System-level** (`features/nix.nix`):
  - Nix package installation
  - Core Nix daemon settings
  - Binary cache configuration
  - Garbage collection settings
  - Trust and security settings

- **User-level** (`modules/home/nix.nix`):
  - Reserved for user-specific overrides (currently empty)
  - Available for future user-specific settings if needed

#### PATH Ordering
The PATH is correctly ordered with user paths taking precedence:
1. `/etc/profiles/per-user/hank/bin` (home-manager)
2. `/run/current-system/sw/bin` (nix-darwin)

This allows users to override system binaries if needed.

## Configuration Changes Made

### 1. Centralized Nix Management
```nix
# features/nix.nix
{
  nix = {
    package = pkgs.nix;  # Explicitly set the package
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # ... other settings
    };
  };
}
```

### 2. Simplified Home Manager
```nix
# modules/home/nix.nix
{
  # Nix package and core settings are managed at the system level
  # This module is reserved for user-specific configurations if needed
}
```

### 3. Cleaned Up Defaults
- Removed duplicate nix settings from `modules/shared/defaults.nix`
- Added useful shell aliases for modern CLI tools
- Simplified environment variables

### 4. Modular Shell Configuration
- Separated shell tools into `features/shell.nix`
- Avoided duplication between darwin and shell modules
- Added modern CLI tool replacements (ripgrep, fd, bat, eza)

## Recommendations

1. **Always use system-level configuration** for Nix itself
2. **Reserve home-manager** for user-specific application settings
3. **Avoid setting `nix.package`** in multiple locations
4. **Use `features/` modules** for cross-platform system settings
5. **Use `modules/darwin/`** for macOS-specific settings only

## Benefits of This Approach

1. **No conflicts**: Single source of truth for Nix configuration
2. **Clear ownership**: System vs user settings are clearly separated
3. **Maintainable**: Easier to debug and update
4. **Flexible**: Users can still override if needed
5. **Idiomatic**: Follows Nix community best practices

## Future Considerations

- If user-specific Nix settings are needed, add them to `modules/home/nix.nix`
- Consider using `lib.mkForce` only when absolutely necessary
- Keep monitoring for any PATH-related issues with `which -a <command>`
