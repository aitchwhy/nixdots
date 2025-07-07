#!/usr/bin/env bash
# Test individual module evaluation

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

echo "🧪 Testing Nix module evaluation..."

# Function to test a module
test_module() {
    local module=$1
    local module_name=$(basename "$module")
    
    echo -n "  Testing $module... "
    
    # Create a minimal test expression based on module type
    local test_expr
    if [[ "$module" == *"darwin"* ]]; then
        test_expr="
        let
            pkgs = import <nixpkgs> { system = \"aarch64-darwin\"; };
            lib = pkgs.lib;
            config = {};
        in import ./$module { inherit pkgs lib config; }"
    elif [[ "$module" == *"home"* ]] || [[ "$module" == *"users"* ]]; then
        test_expr="
        let
            pkgs = import <nixpkgs> { system = \"aarch64-darwin\"; };
            lib = pkgs.lib;
            config = {};
            inputs = {};
            self = { homeModules.default = ./modules/home.nix; };
        in import ./$module { inherit pkgs lib config inputs self; }"
    else
        test_expr="
        let
            pkgs = import <nixpkgs> { system = \"aarch64-darwin\"; };
            lib = pkgs.lib;
            config = {};
            inputs = {};
        in import ./$module { inherit pkgs lib config inputs; }"
    fi
    
    if output=$(nix-instantiate --eval -E "$test_expr" 2>&1); then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        echo -e "  ${RED}Error:${NC} $output" | head -5
        ((ERRORS++))
    fi
}

# Test flake evaluation
echo -e "\n📦 Testing flake..."
echo -n "  Checking flake syntax... "
if nix flake check --no-build 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    ((ERRORS++))
fi

# Test individual modules
echo -e "\n🔧 Testing individual modules..."

# Test core modules
for module in modules/*.nix; do
    if [[ -f "$module" ]]; then
        test_module "$module"
    fi
done

# Test machine configurations
echo -e "\n🖥️  Testing machine configurations..."
for machine in machines/*.nix; do
    if [[ -f "$machine" ]]; then
        test_module "$machine"
    fi
done

# Test user configurations
echo -e "\n👤 Testing user configurations..."
for user in users/*.nix; do
    if [[ -f "$user" ]]; then
        test_module "$user"
    fi
done

# Test that modules don't have circular dependencies
echo -e "\n🔄 Checking for circular dependencies..."
echo -n "  Analyzing module imports... "
# This is a simplified check - in reality we'd need more sophisticated analysis
if grep -r "import.*import.*import" modules/ 2>/dev/null; then
    echo -e "${YELLOW}⚠ Potential circular dependency${NC}"
    ((WARNINGS++))
else
    echo -e "${GREEN}✓${NC}"
fi

# Summary
echo -e "\n📊 Test Summary"
echo "==============="
if [[ $ERRORS -eq 0 ]]; then
    if [[ $WARNINGS -eq 0 ]]; then
        echo -e "${GREEN}✓ All tests passed!${NC}"
    else
        echo -e "${YELLOW}⚠ Tests passed with $WARNINGS warnings${NC}"
    fi
    exit 0
else
    echo -e "${RED}✗ $ERRORS tests failed${NC}"
    exit 1
fi