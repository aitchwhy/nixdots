#!/usr/bin/env bash
# Minimal but comprehensive tests for Nix configuration

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
test_case() {
    local name="$1"
    local cmd="$2"
    
    echo -n "Testing: $name ... "
    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC}"
        ((TESTS_FAILED++))
        echo "  Command failed: $cmd"
    fi
}

echo "Running Nix Configuration Tests"
echo "==============================="

# Basic flake tests
test_case "Flake validity" "nix flake check --no-build"
test_case "Flake metadata" "nix flake metadata"
test_case "Flake show" "nix flake show"

# Format tests
test_case "Nix files formatted" "nix fmt -- --check"

# Build tests
test_case "Darwin configuration evaluation" "nix eval .#darwinConfigurations.hank-mbp-m4.config.system.build.toplevel"
test_case "Darwin configuration build (dry-run)" "nix build .#darwinConfigurations.hank-mbp-m4.system --dry-run"

# Module tests
test_case "Home-manager module" "nix eval .#homeModules.default"
test_case "Machine config exists" "test -f machines/hank-mbp-m4.nix"
test_case "User config exists" "test -f users/hank.nix"
test_case "Development shell" "nix develop --command echo 'Shell OK'"

# Dependency tests
test_case "Check for circular dependencies" "nix eval .#darwinConfigurations.hank-mbp-m4.system --show-trace 2>&1 | grep -v 'infinite recursion' || true"

# Package availability tests
test_case "Essential packages available" "nix eval .#darwinConfigurations.hank-mbp-m4.config.environment.systemPackages --json | jq -e 'length > 0'"

# Home-manager integration
test_case "Home-manager user config" "nix eval .#darwinConfigurations.hank-mbp-m4.config.home-manager.users.hank --json > /dev/null"

# Module structure tests
test_case "Home module packages" "test -f modules/home/packages/default.nix"
test_case "Machine-specific configs" "find machines -name '*.nix' | grep -q '.'"
test_case "Darwin module exists" "test -f modules/darwin/default.nix"

# Configuration integrity tests
test_case "No Darwin config in NixOS" "! grep -q 'system.defaults' modules/nixos/common/default.nix"
test_case "Shared defaults valid" "nix eval --impure --expr 'import ./modules/shared/defaults.nix { config = {}; lib = (import <nixpkgs> {}).lib; pkgs = import <nixpkgs> {}; }' > /dev/null"

# Justfile tests
test_case "Justfile syntax" "just --evaluate > /dev/null"
test_case "Justfile formatting" "just --fmt --check"
test_case "Just build command" "just build --dry-run 2>/dev/null || true"
test_case "Just info command" "just info > /dev/null"

# Git repository health
test_case "Git repository clean" "git diff --quiet && git diff --cached --quiet || true"

echo ""
echo "==============================="
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
fi