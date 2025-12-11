#!/bin/bash
# Validate all Docker Compose files in the repository
# This script can run on any platform (MacBook, Linux) to check syntax

set -e

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
    
    # Validate compose syntax (without requiring .env file)
    # Use --env-file /dev/null to ignore missing .env
    if docker compose -f "$compose_file" config --quiet 2>&1 | grep -q "error\|Error\|ERROR"; then
        echo "   ❌ Validation failed"
        docker compose -f "$compose_file" config 2>&1 | head -20
        return 1
    else
        # Try to validate (may fail if .env is missing, but that's OK for syntax check)
        if docker compose -f "$compose_file" config > /dev/null 2>&1; then
            echo "   ✅ Valid"
            return 0
        else
            # Check if error is just about missing .env
            if docker compose -f "$compose_file" config 2>&1 | grep -q "\.env"; then
                echo "   ⚠️  Valid syntax (missing .env, expected)"
                return 0
            else
                echo "   ❌ Validation failed"
                docker compose -f "$compose_file" config 2>&1 | head -20
                return 1
            fi
        fi
    fi
}

# Validate all compose files in servers/
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

# Validate compose files in services/ (if exists)
if [ -d "$REPO_ROOT/services" ]; then
    for service_dir in "$REPO_ROOT/services"/*/; do
        if [ -d "$service_dir" ]; then
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
if [ $ERRORS -eq 0 ]; then
    echo "✅ All compose files validated successfully! ($VALIDATED files)"
    exit 0
else
    echo "❌ Validation failed: $ERRORS error(s) found, $VALIDATED passed"
    exit 1
fi

