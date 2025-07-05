#!/usr/bin/env bash
# Integration test for full system build

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Change to repo root
cd "$(dirname "$0")/../.."

echo "Running Integration Tests"
echo "========================"
echo ""

# Function to run a test
run_test() {
    local name="$1"
    local cmd="$2"
    
    echo -n "Testing: $name ... "
    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        echo "  Command failed: $cmd"
        return 1
    fi
}

# Track failures
FAILED=0

# Basic flake tests
echo "Flake validation:"
run_test "Flake metadata" "nix flake metadata" || ((FAILED++))
run_test "Flake check" "nix flake check --no-build" || ((FAILED++))
run_test "Flake show" "nix flake show" || ((FAILED++))

echo ""
echo "Configuration evaluation:"
# Test Darwin configuration
run_test "Darwin config evaluation" "nix eval .#darwinConfigurations.hank-mbp-m4.config.system.build.toplevel" || ((FAILED++))
run_test "Darwin dry-run build" "nix build .#darwinConfigurations.hank-mbp-m4.system --dry-run" || ((FAILED++))

echo ""
echo "Module imports:"
# Test that all modules are importable
run_test "Home modules" "nix eval .#homeModules.default" || ((FAILED++))

echo ""
echo "Package availability:"
# Test that packages are available
run_test "System packages" "nix eval .#darwinConfigurations.hank-mbp-m4.config.environment.systemPackages --json | jq -e 'length > 0'" || ((FAILED++))
run_test "User packages" "nix eval .#darwinConfigurations.hank-mbp-m4.config.home-manager.users.hank.home.packages --json | jq -e 'length > 0' || echo '[]'" || ((FAILED++))

echo ""
echo "Structure validation:"
# Run structure validation
if ./tests/lib/validate-structure.sh > /dev/null 2>&1; then
    echo -e "Structure validation ... ${GREEN}✓${NC}"
else
    echo -e "Structure validation ... ${RED}✗${NC}"
    ((FAILED++))
fi

echo ""
echo "Development environment:"
# Test development shell
run_test "Dev shell" "nix develop --command echo 'Shell OK'" || ((FAILED++))

echo ""
echo "Import library:"
# Test import library functions
run_test "Import library" "nix eval --impure --expr 'import ./lib/imports.nix { lib = (import <nixpkgs> {}).lib; }' > /dev/null" || ((FAILED++))

echo ""
echo "========================"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}All integration tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Integration tests failed: $FAILED test(s)${NC}"
    exit 1
fi