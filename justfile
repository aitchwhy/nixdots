# 🚀 Nix Darwin Configuration
# Quick commands for managing your nix-darwin setup
# Run `just` to see all available commands

# Set shell for recipe execution
set shell := ["bash", "-uc"]

# Default host - automatically detect or fallback
HOST := env_var_or_default("HOST", "hank-mbp-m4")

# Color output helpers
bold := '\033[1m'
green := '\033[32m'
yellow := '\033[33m'
blue := '\033[34m'
reset := '\033[0m'

# Default recipe - show available commands with descriptions
@default:
    echo "{{blue}}{{bold}}Nix Darwin Commands{{reset}}"
    echo ""
    just --list --unsorted
    echo ""
    echo "{{yellow}}Tips:{{reset}}"
    echo "  • Use 'just s' as shorthand for 'switch'"
    echo "  • Set HOST env var to target different machines"
    echo "  • Run 'just test' before pushing changes"

# 🔄 Switch to configuration (rebuild + activate)
[group('core')]
switch: && _success
    darwin-rebuild switch --flake .#{{HOST}}

# 🔄 Shorthand for switch
[group('core')]
@s: switch

# 🏗️  Build configuration without switching
[group('core')]
build:
    nix build .#darwinConfigurations.{{HOST}}.system --no-link --print-out-paths

# 🧪 Test configuration (build + check + format check)
[group('test')]
test: check fmt-check build
    @echo "{{green}}✓ All tests passed!{{reset}}"

# 🔍 Check flake and evaluate configuration
[group('test')]
check:
    nix flake check
    nix eval .#darwinConfigurations.{{HOST}}.config.system.build.toplevel

# 📝 Format all Nix files
[group('code')]
fmt:
    nix fmt
    @echo "{{green}}✓ Formatted all .nix files{{reset}}"

# 🔍 Check if files are properly formatted
[group('test')]
fmt-check:
    nix fmt -- --check
    @echo "{{green}}✓ All files properly formatted{{reset}}"

# 🔄 Update all flake inputs
[group('maintain')]
update:
    nix flake update
    @echo "{{green}}✓ Updated all inputs{{reset}}"

# 🔄 Update specific input
[group('maintain')]
update-input input:
    nix flake lock --update-input {{input}}
    @echo "{{green}}✓ Updated {{input}}{{reset}}"

# 🧹 Garbage collect old generations (keeps 7 days)
[group('maintain')]
gc:
    sudo nix-collect-garbage --delete-older-than 7d
    nix store optimise
    @echo "{{green}}✓ Garbage collected{{reset}}"

# 🧹 Deep clean - remove all old generations
[group('maintain')]
gc-all:
    sudo nix-collect-garbage -d
    nix store optimise
    @echo "{{yellow}}⚠️  Removed ALL old generations{{reset}}"

# 📊 Show system info and current generation
[group('info')]
info:
    @echo "{{bold}}Current Configuration:{{reset}}"
    darwin-rebuild --list-generations | tail -n 5
    @echo ""
    @echo "{{bold}}Flake Info:{{reset}}"
    nix flake metadata
    @echo ""
    @echo "{{bold}}System:{{reset}} {{HOST}}"

# 🔍 What would change? (dry run)
[group('info')]
diff:
    nixos-rebuild build --flake .#{{HOST}}
    nvd diff /run/current-system result

# 🚀 Development shell
[group('dev')]
dev:
    nix develop -c $SHELL

# 🔐 Debug a specific derivation
[group('dev')]
debug pkg:
    nix repl --expr 'let flake = builtins.getFlake (toString ./.); in flake.darwinConfigurations.{{HOST}}.pkgs.{{pkg}}'

# 🎯 Run a command in pure nix shell
[group('dev')]
run cmd *args:
    nix run nixpkgs#{{cmd}} -- {{args}}

# 🏥 Doctor - check system health
[group('info')]
doctor:
    @echo "{{bold}}Checking system health...{{reset}}"
    @echo -n "Nix: "
    nix --version
    @echo -n "Darwin Rebuild: "
    darwin-rebuild --version || echo "Not found"
    @echo -n "Git status: "
    git status --porcelain | wc -l | xargs -I {} sh -c 'if [ {} -eq 0 ]; then echo "{{green}}Clean{{reset}}"; else echo "{{yellow}}Dirty ({} files){{reset}}"; fi'
    @echo ""
    nix doctor 2>/dev/null || nix store ping

# 📦 List all installed packages
[group('info')]
packages:
    nix eval .#darwinConfigurations.{{HOST}}.config.environment.systemPackages --apply 'map (p: p.name)'

# 🔄 Rollback to previous generation
[group('maintain')]
rollback:
    darwin-rebuild --rollback

# Helper for success messages
@_success:
    echo "{{green}}{{bold}}✓ Success!{{reset}} Configuration switched for {{HOST}}"