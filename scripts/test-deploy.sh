#!/bin/bash
# Test deploy script - helps test deployments on MacBook with platform emulation
# Usage: ./scripts/test-deploy.sh <server> [command]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SERVER="$1"
COMMAND="${2:-dry-run}"

if [ -z "$SERVER" ]; then
    echo "❌ Usage: $0 <server> [command]"
    echo ""
    echo "Available servers:"
    ls -d "$REPO_ROOT/servers"/*/ 2>/dev/null | sed 's|.*/||' | sed 's|/$||' | sed 's/^/  - /'
    echo ""
    echo "Available commands:"
    echo "  dry-run      - Show what would be deployed (default)"
    echo "  test-deploy  - Actually deploy with platform emulation"
    echo "  test-down    - Stop test containers"
    echo ""
    exit 1
fi

SERVER_DIR="$REPO_ROOT/servers/$SERVER"

if [ ! -d "$SERVER_DIR" ]; then
    echo "❌ Server directory not found: $SERVER_DIR"
    exit 1
fi

cd "$SERVER_DIR"

case "$COMMAND" in
    dry-run)
        echo "🔍 Dry run for $SERVER..."
        make dry-run
        ;;
    test-deploy)
        echo "🧪 Test deploying $SERVER (with platform emulation)..."
        echo "⚠️  This will start containers on your MacBook"
        read -p "Continue? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            make test-deploy
            echo ""
            echo "✅ Test deployment started!"
            echo "   Check logs: make logs"
            echo "   Stop: make test-down"
        else
            echo "Cancelled."
        fi
        ;;
    test-down)
        echo "🛑 Stopping test containers for $SERVER..."
        make test-down
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo "Available: dry-run, test-deploy, test-down"
        exit 1
        ;;
esac

