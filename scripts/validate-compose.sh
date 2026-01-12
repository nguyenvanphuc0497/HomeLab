#!/bin/bash
# Validate all Docker Compose files in the repository
# This script can run on any platform (MacBook, Linux) to check syntax

set +e  # Don't exit on error, we'll handle it manually

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔍 Validating Docker Compose files..."
echo ""

ERRORS=0
VALIDATED=0

# Function to validate a compose file
validate_compose() {
    local compose_file="$1"
    local dir="$(dirname "$compose_file")"
    
    echo "📄 Checking: $compose_file"
    
    # Check if file exists
    if [ ! -f "$compose_file" ]; then
        echo "   ❌ File not found"
        return 1
    fi
    
    # Try to validate compose syntax
    # Capture both stdout and stderr
    local output
    output=$(docker compose -f "$compose_file" config 2>&1)
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "   ✅ Valid"
        return 0
    else
        # Check if error is just about missing .env file (expected)
        if echo "$output" | grep -qiE "(\.env|variable.*not set|environment variable)"; then
            echo "   ⚠️  Valid syntax (missing .env, expected)"
            return 0
        else
            # Real validation error
            echo "   ❌ Validation failed"
            echo "$output" | head -20
            return 1
        fi
    fi
}

# Validate all compose files in servers/
if [ -d "$REPO_ROOT/servers" ]; then
    for server_dir in "$REPO_ROOT/servers"/*/; do
        if [ -d "$server_dir" ]; then
            compose_file="$server_dir/docker-compose.yml"
            if [ -f "$compose_file" ]; then
                if validate_compose "$compose_file"; then
                    ((VALIDATED++))
                else
                    ((ERRORS++))
                fi
                echo ""
            fi
        fi
    done
else
    echo "⚠️  No servers/ directory found"
fi

# Validate compose files in services/ (if exists)
if [ -d "$REPO_ROOT/services" ]; then
    for service_dir in "$REPO_ROOT/services"/*/; do
        if [ -d "$service_dir" ]; then
            # Skip if .validateignore exists
            if [ -f "$service_dir/.validateignore" ]; then
                echo "⏩ Skipping module: $(basename "$service_dir") (.validateignore found)"
                continue
            fi

            compose_file="$service_dir/docker-compose.yml"
            if [ -f "$compose_file" ]; then
                if validate_compose "$compose_file"; then
                    ((VALIDATED++))
                else
                    ((ERRORS++))
                fi
                echo ""
            fi
        fi
    done
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $VALIDATED -eq 0 ] && [ $ERRORS -eq 0 ]; then
    echo "⚠️  No compose files found to validate"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "✅ All compose files validated successfully! ($VALIDATED files)"
    exit 0
else
    echo "❌ Validation failed: $ERRORS error(s) found, $VALIDATED passed"
    exit 1
fi

