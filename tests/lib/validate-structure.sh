#!/usr/bin/env bash
# Validate directory structure conventions

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Change to repo root
cd "$(dirname "$0")/../.."

# Track validation results
ERRORS=0

# Helper functions
error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}!${NC} $1"
}

echo "Validating Nixdots Structure"
echo "============================"
echo ""

# Check directory structure
echo "Checking directory structure:"

# Required directories
for dir in features lib machines modules modules/darwin modules/nixos modules/shared modules/home users tests docs; do
    if [ -d "$dir" ]; then
        success "Directory exists: $dir"
    else
        error "Missing required directory: $dir"
    fi
done

# Check that old structure is gone
if [ -d "modules/home/packages" ]; then
    error "User packages should not be in modules/home/packages/"
else
    success "No packages in modules/home/packages/"
fi

echo ""
echo "Checking module organization:"

# Check features directory only contains system features
valid_features=("nix.nix" "shell.nix" "users.nix")
for file in features/*.nix; do
    if [ -f "$file" ]; then
        basename=$(basename "$file")
        if [[ " ${valid_features[@]} " =~ " ${basename} " ]]; then
            success "Valid feature: $basename"
        else
            error "Invalid file in features/: $basename"
        fi
    fi
done

# Check for wrapper files that should have been removed
if [ -f "lib/default.nix" ]; then
    error "Wrapper file still exists: lib/default.nix"
else
    success "No wrapper file: lib/default.nix"
fi

if [ -d "modules/home/core" ]; then
    error "Unnecessary nesting: modules/home/core/"
else
    success "No unnecessary nesting in modules/home/"
fi

echo ""
echo "Checking import patterns:"

# Check for old import patterns
if grep -r "filter (fn: fn != \"default.nix\")" modules/ --include="*.nix" | grep -v "importLib\|imports.nix"; then
    warning "Found old import pattern that should use importLib"
fi

echo ""
echo "Checking user package organization:"

# Check that user packages are in the right place
if [ -d "users/hank/packages" ]; then
    success "User packages directory exists"
    
    # Check for expected package files
    expected_packages=("cloud-infra.nix" "data-tools.nix" "development.nix" "media-apps.nix" "utilities.nix" "default.nix")
    for pkg in "${expected_packages[@]}"; do
        if [ -f "users/hank/packages/$pkg" ]; then
            success "User package file exists: $pkg"
        else
            error "Missing user package file: $pkg"
        fi
    done
else
    error "User packages directory missing: users/hank/packages/"
fi

echo ""
echo "Checking configuration options:"

# Check that options module exists
if [ -f "modules/shared/options.nix" ]; then
    success "Configuration options module exists"
else
    error "Missing configuration options module"
fi

echo ""
echo "Checking documentation:"

# Check for architecture documentation
if [ -f "docs/ARCHITECTURE.md" ] || [ -f "ARCHITECTURE.md" ]; then
    success "Architecture documentation exists"
else
    warning "Missing architecture documentation"
fi

echo ""
echo "============================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}All structure validations passed!${NC}"
    exit 0
else
    echo -e "${RED}Structure validation failed with $ERRORS errors${NC}"
    exit 1
fi