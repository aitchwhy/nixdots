#!/usr/bin/env bash
# Unit tests for individual modules

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Change to repo root
cd "$(dirname "$0")/../.."

# Test function
test_module() {
    local name="$1"
    local module="$2"
    
    echo -n "Testing module: $name ... "
    
    # Create a minimal test expression
    local test_expr="
    let
      pkgs = import <nixpkgs> {};
      lib = pkgs.lib;
      config = {};
      inputs = {};
      self = {};
    in
      import $module { inherit config lib pkgs inputs self; }
    "
    
    if nix-instantiate --eval --expr "$test_expr" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC}"
        ((TESTS_FAILED++))
        echo "  Module failed: $module"
        # Show error details if verbose
        if [ "${VERBOSE:-}" = "1" ]; then
            nix-instantiate --eval --expr "$test_expr" 2>&1 | sed 's/^/    /'
        fi
    fi
}

echo "Running Module Unit Tests"
echo "========================="

# Test shared modules
echo ""
echo "Testing shared modules:"
test_module "shared/defaults" "./modules/shared/defaults.nix"
test_module "shared/options" "./modules/shared/options.nix"

# Test Darwin modules
echo ""
echo "Testing Darwin modules:"
test_module "darwin/default" "./modules/darwin/default.nix"
for module in ./modules/darwin/homebrew/*.nix; do
    if [ -f "$module" ]; then
        test_module "darwin/homebrew/$(basename "$module")" "$module"
    fi
done

# Test NixOS modules
echo ""
echo "Testing NixOS modules:"
test_module "nixos/default" "./modules/nixos/default.nix"

# Test home modules
echo ""
echo "Testing home modules:"
for module in ./modules/home/*.nix; do
    if [ -f "$module" ] && [ "$(basename "$module")" != "default.nix" ]; then
        test_module "home/$(basename "$module")" "$module"
    fi
done

# Test features
echo ""
echo "Testing feature modules:"
for module in ./features/*.nix; do
    if [ -f "$module" ]; then
        test_module "features/$(basename "$module")" "$module"
    fi
done

# Test lib modules
echo ""
echo "Testing library modules:"
test_module "lib/imports" "./lib/imports.nix"
test_module "lib/mkSystem" "./lib/mkSystem.nix"

echo ""
echo "========================="
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}All module tests passed!${NC}"
fi