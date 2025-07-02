# Like GNU `make`, but `just` rustier.
# https://just.systems/
# run `just` from this directory to see available commands

# List available recipes
default:
    @just --list

# Update flake inputs
update:
    nix flake update

# Format all nix files
fmt:
    nix fmt

# Check flake
check:
    nix flake check

# Build the darwin configuration
build host="hank-mbp-m4":
    nix build .#darwinConfigurations.{{host}}.system

# Switch to the darwin configuration
switch host="hank-mbp-m4":
    darwin-rebuild switch --flake .#{{host}}

# Build and switch in one command
rebuild host="hank-mbp-m4": build switch

# Clean up old generations
clean:
    sudo nix-collect-garbage -d

# Show flake info
info:
    nix flake show
    nix flake metadata

# Enter development shell
dev:
    nix develop

# Show what would change without applying
dry-run host="hank-mbp-m4":
    darwin-rebuild build --flake .#{{host}} --dry-run

# Migration helper: backup old configuration
backup-old:
    @echo "Backing up old configuration..."
    @mkdir -p backups/$(date +%Y%m%d_%H%M%S)
    @cp -r configurations backups/$(date +%Y%m%d_%H%M%S)/ || true
    @cp -r modules backups/$(date +%Y%m%d_%H%M%S)/ || true
    @echo "Backup created in backups/$(date +%Y%m%d_%H%M%S)/"

# Migration helper: clean old structure (run after verifying new config works)
clean-old:
    @echo "This will remove the old directory structure. Are you sure? (y/N)"
    @read -r response && [ "$$response" = "y" ] || exit 1
    rm -rf configurations modules
    @echo "Old structure removed. Don't forget to commit these changes."
