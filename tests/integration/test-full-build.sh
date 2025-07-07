#!/usr/bin/env bash
# Integration test for full system build

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "🏗️  Integration Test: Full System Build"
echo "====================================="

# Default host
HOST="${HOST:-hank-mbp-m4}"

# Function to measure time
measure_time() {
    local start=$1
    local end=$2
    local duration=$((end - start))
    echo "$((duration / 60))m $((duration % 60))s"
}

# Check prerequisites
echo -e "\n📋 Checking prerequisites..."
prerequisites=(
    "nix"
    "darwin-rebuild"
    "git"
)

for cmd in "${prerequisites[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $cmd found"
    else
        echo -e "  ${RED}✗${NC} $cmd not found"
        exit 1
    fi
done

# Run pre-build validation
echo -e "\n🔍 Running pre-build validation..."
if ./tests/lib/validate-structure.sh; then
    echo -e "  ${GREEN}✓${NC} Structure validation passed"
else
    echo -e "  ${RED}✗${NC} Structure validation failed"
    exit 1
fi

# Test module evaluation
echo -e "\n🧪 Testing module evaluation..."
if ./tests/unit/test-modules.sh; then
    echo -e "  ${GREEN}✓${NC} Module tests passed"
else
    echo -e "  ${RED}✗${NC} Module tests failed"
    exit 1
fi

# Dry run build
echo -e "\n🏃 Running dry build..."
START_TIME=$(date +%s)
if nix build ".#darwinConfigurations.$HOST.system" --dry-run 2>&1 | grep -q "would be built"; then
    END_TIME=$(date +%s)
    echo -e "  ${GREEN}✓${NC} Dry run completed in $(measure_time $START_TIME $END_TIME)"
else
    echo -e "  ${RED}✗${NC} Dry run failed"
    exit 1
fi

# Check for evaluation warnings
echo -e "\n⚠️  Checking for evaluation warnings..."
WARNINGS=$(nix build ".#darwinConfigurations.$HOST.system" --dry-run 2>&1 | grep -i "warning" || true)
if [[ -z "$WARNINGS" ]]; then
    echo -e "  ${GREEN}✓${NC} No warnings found"
else
    echo -e "  ${YELLOW}⚠${NC} Warnings found:"
    echo "$WARNINGS" | sed 's/^/    /'
fi

# Actual build test (only in CI or with explicit flag)
if [[ "${CI:-false}" == "true" ]] || [[ "${FULL_BUILD_TEST:-false}" == "true" ]]; then
    echo -e "\n🔨 Running full build test..."
    START_TIME=$(date +%s)
    
    if nix build ".#darwinConfigurations.$HOST.system" --no-link; then
        END_TIME=$(date +%s)
        echo -e "  ${GREEN}✓${NC} Build completed in $(measure_time $START_TIME $END_TIME)"
        
        # Check build output
        BUILD_PATH=$(nix build ".#darwinConfigurations.$HOST.system" --no-link --print-out-paths)
        if [[ -d "$BUILD_PATH" ]]; then
            echo -e "  ${GREEN}✓${NC} Build output exists at $BUILD_PATH"
            
            # Check activation script exists
            if [[ -f "$BUILD_PATH/activate" ]]; then
                echo -e "  ${GREEN}✓${NC} Activation script found"
            else
                echo -e "  ${RED}✗${NC} Activation script missing"
                exit 1
            fi
        fi
    else
        echo -e "  ${RED}✗${NC} Build failed"
        exit 1
    fi
else
    echo -e "\n${BLUE}ℹ${NC} Skipping full build test (set FULL_BUILD_TEST=true to run)"
fi

# Test flake outputs
echo -e "\n📦 Testing flake outputs..."
outputs=(
    "darwinConfigurations.$HOST"
    "homeModules.default"
    "devShells.aarch64-darwin.default"
    "formatter.aarch64-darwin"
)

for output in "${outputs[@]}"; do
    echo -n "  Testing $output... "
    if nix eval ".#$output" &>/dev/null; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        exit 1
    fi
done

# Performance check
echo -e "\n⚡ Performance metrics..."
echo -n "  Evaluating build time... "
START_TIME=$(date +%s)
nix eval ".#darwinConfigurations.$HOST.system.drvPath" &>/dev/null
END_TIME=$(date +%s)
EVAL_TIME=$(measure_time $START_TIME $END_TIME)
echo -e "${GREEN}$EVAL_TIME${NC}"

if [[ $((END_TIME - START_TIME)) -gt 300 ]]; then
    echo -e "  ${YELLOW}⚠${NC} Evaluation took longer than 5 minutes"
fi

# Memory usage check (approximate)
echo -n "  Checking closure size... "
CLOSURE_SIZE=$(nix path-info -S ".#darwinConfigurations.$HOST.system" 2>/dev/null | awk '{print $2}' || echo "0")
CLOSURE_SIZE_MB=$((CLOSURE_SIZE / 1024 / 1024))
echo -e "${GREEN}${CLOSURE_SIZE_MB}MB${NC}"

if [[ $CLOSURE_SIZE_MB -gt 5000 ]]; then
    echo -e "  ${YELLOW}⚠${NC} Closure size exceeds 5GB"
fi

# Summary
echo -e "\n✅ ${GREEN}All integration tests passed!${NC}"
echo -e "\n📊 Summary:"
echo "  - Host: $HOST"
echo "  - Evaluation time: $EVAL_TIME"
echo "  - Closure size: ${CLOSURE_SIZE_MB}MB"
echo "  - All modules valid"
echo "  - Build configuration correct"

exit 0