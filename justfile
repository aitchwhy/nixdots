# Quick commands for Nix Darwin - Run 'just' to see all
set shell := ["bash", "-uc"]

# Auto-detect host or use default
host := env_var_or_default("HOST", "hank-mbp-m4")

# Show available commands
default:
    @just --list

# Switch configuration (rebuild + activate) [alias: s]
switch:
    darwin-rebuild switch --flake .#{{host}}

alias s := switch

# Build without switching [alias: b]
build:
    darwin-rebuild build --flake .#{{host}}

alias b := build

# Run all checks
check: lint test
    @echo "✓ All checks passed"

# Lint and format check
lint:
    nix fmt -- --check
    nix flake check

# Test the build
test:
    nix build .#darwinConfigurations.{{host}}.system --no-link --print-out-paths

# Format all nix files
fmt:
    nix fmt

# Update flake inputs [alias: u]
update:
    nix flake update

alias u := update

# Garbage collect (keep 7 days) [alias: gc]
clean:
    sudo nix-collect-garbage --delete-older-than 7d
    nix store optimise

alias gc := clean

# Show system info [alias: i]
info:
    @echo "Host: {{host}}"
    @echo "Generation:"
    @darwin-rebuild --list-generations 2>/dev/null | tail -n 1 || echo "  (no access to system profile)"
    @echo "Flake:"
    @nix flake metadata --json | jq -r '.url' 2>/dev/null || echo "  git+file://$(pwd)"

alias i := info

# Development shell
dev:
    nix develop -c $SHELL

# Quick health check
doctor:
    @which nix > /dev/null && echo "✓ Nix installed" || echo "✗ Nix not found"
    @which darwin-rebuild > /dev/null && echo "✓ Darwin-rebuild installed" || echo "✗ Darwin-rebuild not found"
    @test -f flake.nix && echo "✓ Flake found" || echo "✗ No flake.nix"
    @git status --porcelain | wc -l | xargs -I {} test {} -eq 0 && echo "✓ Git clean" || echo "! Git dirty"