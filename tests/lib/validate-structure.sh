#!/usr/bin/env bash
# Validate directory structure and file conventions

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for errors
ERRORS=0

echo "🔍 Validating Nix configuration structure..."

# Check required directories
echo -e "\n📁 Checking directory structure..."
REQUIRED_DIRS=(
    "modules"
    "machines"
    "users"
    "tests"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir exists"
    else
        echo -e "  ${RED}✗${NC} $dir missing"
        ((ERRORS++))
    fi
done

# Check required files
echo -e "\n📄 Checking required files..."
REQUIRED_FILES=(
    "flake.nix"
    "flake.lock"
    "README.md"
    "justfile"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo -e "  ${GREEN}✓${NC} $file exists"
    else
        echo -e "  ${RED}✗${NC} $file missing"
        ((ERRORS++))
    fi
done

# Validate Nix files
echo -e "\n🧪 Validating Nix files..."
while IFS= read -r -d '' file; do
    echo -n "  Checking $file... "
    if nix-instantiate --parse "$file" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗ Parse error${NC}"
        ((ERRORS++))
    fi
done < <(find . -name "*.nix" -not -path "./.direnv/*" -not -path "./.git/*" -print0)

# Check for common issues
echo -e "\n🔎 Checking for common issues..."

# Check for hardcoded usernames (except in user-specific files)
echo -n "  Checking for hardcoded usernames... "
HARDCODED=$(grep -r "hank" --include="*.nix" --exclude-dir=".git" --exclude-dir=".direnv" . | grep -v "users/hank.nix" | grep -v "machines/hank-mbp-m4.nix" || true)
if [[ -z "$HARDCODED" ]]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${YELLOW}⚠ Found hardcoded usernames${NC}"
    echo "$HARDCODED" | head -5
fi

# Check module sizes
echo -e "\n📏 Checking module sizes..."
while IFS= read -r -d '' file; do
    LINES=$(wc -l < "$file")
    if [[ $LINES -gt 200 ]]; then
        echo -e "  ${YELLOW}⚠${NC} $file has $LINES lines (consider splitting)"
    fi
done < <(find modules -name "*.nix" -print0 2>/dev/null || true)

# Summary
echo -e "\n📊 Validation Summary"
echo "===================="
if [[ $ERRORS -eq 0 ]]; then
    echo -e "${GREEN}✓ All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Found $ERRORS errors${NC}"
    exit 1
fi