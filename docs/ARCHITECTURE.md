# Nixdots Architecture

This document describes the architecture and organization of the nixdots repository, a modular Nix configuration for both macOS (nix-darwin) and NixOS systems.

## Directory Structure

```
nixdots/
├── features/           # Core system features (always applied)
│   ├── nix.nix        # Nix daemon configuration
│   ├── shell.nix      # System-wide shell settings
│   └── users.nix      # User account definitions
├── lib/               # Helper functions and utilities
│   ├── imports.nix    # Import utility functions
│   └── mkSystem.nix   # System builder functions
├── machines/          # Host-specific configurations
│   └── ${hostname}.nix
├── modules/           # Reusable configuration modules
│   ├── darwin/        # macOS-specific modules
│   │   ├── default.nix
│   │   └── homebrew/  # Homebrew package management
│   ├── home/          # Shared home-manager modules
│   │   ├── *.nix      # Individual program configs
│   │   └── default.nix # Auto-imports all modules
│   ├── nixos/         # NixOS-specific modules
│   │   └── default.nix
│   └── shared/        # Cross-platform modules
│       ├── defaults.nix # Shared system defaults
│       └── options.nix  # Configuration options
├── users/             # User-specific configurations
│   └── ${username}/
│       ├── default.nix # User configuration
│       └── packages/   # User-specific packages
├── overlays/          # Package overlays
├── pkgs/              # Custom package definitions
├── tests/             # Test infrastructure
│   ├── integration/   # Full system tests
│   ├── lib/          # Test helpers
│   └── unit/         # Module unit tests
└── docs/             # Documentation
```

## Module Organization

### 1. Features
Core system features that are always included in every configuration:
- **nix.nix**: Nix daemon settings, garbage collection, trusted users
- **shell.nix**: System-wide shell configuration
- **users.nix**: User account creation and management

### 2. Modules
Reusable configuration modules organized by platform:

#### Darwin Modules (`modules/darwin/`)
macOS-specific system configuration:
- System defaults (Finder, Dock, trackpad settings)
- Homebrew integration (casks, brews, taps)
- macOS-specific services

#### NixOS Modules (`modules/nixos/`)
Linux-specific system configuration:
- Boot loader settings
- System services
- Hardware configuration

#### Shared Modules (`modules/shared/`)
Cross-platform configuration:
- **defaults.nix**: Common system settings (timezone, environment variables)
- **options.nix**: Configuration options and feature flags

#### Home Modules (`modules/home/`)
User-level configuration managed by home-manager:
- Individual program configurations (git, neovim, shell tools)
- Auto-imported by default for all users

### 3. Users
User-specific configurations and packages:
- Each user has their own directory
- User packages are organized by category
- Inherits shared home modules

## Import Patterns

### Auto-Import Function
The repository uses a custom import utility (`lib/imports.nix`) that provides:
- `autoImport`: Import all .nix files in a directory
- `autoImportExclude`: Import with exclusion list
- `autoImportDirs`: Import subdirectories with default.nix
- `filterByPlatform`: Platform-specific filtering

### Module Loading Order
1. Features are loaded first (always included)
2. Platform-specific modules (darwin/nixos)
3. Machine-specific configuration
4. User configurations via home-manager

## Configuration Options

The `modules/shared/options.nix` defines configuration options:

```nix
nixdots.profile = "development";  # minimal, development, full
nixdots.features = {
  development.enable = true;
  cloud.enable = true;
  multimedia.enable = false;
  productivity.enable = true;
};
```

These options control which features and packages are enabled.

## Building Systems

Systems are built using the `mkSystem` functions in `lib/mkSystem.nix`:

```nix
# For macOS
mkSystem.mkDarwin {
  hostname = "hostname";
  system = "aarch64-darwin";
  users = { username = import ./users/username.nix; };
}

# For NixOS
mkSystem.mkNixOS {
  hostname = "hostname";
  system = "x86_64-linux";
  users = { username = import ./users/username.nix; };
}
```

## Testing Strategy

### Unit Tests (`tests/unit/`)
- Test individual modules in isolation
- Verify module evaluation without errors
- Check for syntax and basic logic errors

### Integration Tests (`tests/integration/`)
- Test full system builds
- Verify package availability
- Check configuration consistency

### Structure Validation (`tests/lib/`)
- Enforce directory structure conventions
- Validate import patterns
- Check for common mistakes

### CI/CD Pipeline
GitHub Actions workflow that:
1. Runs format checks
2. Executes all test suites
3. Validates on both macOS and Linux
4. Performs dry-run builds

## Best Practices

1. **Separation of Concerns**
   - System vs user configuration
   - Platform-specific vs shared
   - Programs vs packages

2. **Module Reusability**
   - Write modules to be platform-agnostic when possible
   - Use options for configurability
   - Avoid hardcoded values

3. **Import Management**
   - Use the import utility functions
   - Avoid circular dependencies
   - Keep imports explicit and traceable

4. **Testing**
   - Write unit tests for new modules
   - Run integration tests before major changes
   - Use pre-commit hooks for validation

## Adding New Configurations

### Adding a New Machine
1. Create `machines/${hostname}.nix`
2. Define machine-specific settings
3. Add to `flake.nix` darwinConfigurations or nixosConfigurations

### Adding a New User
1. Create `users/${username}/default.nix`
2. Create `users/${username}/packages/` for user packages
3. Reference in machine configuration

### Adding a New Module
1. Create module in appropriate directory
2. Follow existing patterns for options
3. Add unit tests
4. Update documentation

## Maintenance

### Regular Tasks
- Run `nix flake update` to update dependencies
- Execute test suite: `./tests/integration/test-full-build.sh`
- Validate structure: `./tests/lib/validate-structure.sh`
- Format code: `nix fmt`

### Debugging
- Use `--show-trace` for detailed error messages
- Check `nix flake check` for validation
- Run unit tests for specific modules
- Use `nix repl` for interactive debugging