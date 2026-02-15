#!/bin/bash

# Usage: ./manage.sh [command]
# Commands: deploy, down, config, prune, clean

COMMAND=$1
SERVERS_DIR="servers"

if [ -z "$COMMAND" ]; then
    echo "Usage: $0 [deploy|down|config]"
    exit 1
fi

# Check if servers directory exists
if [ ! -d "$SERVERS_DIR" ]; then
    echo "❌ Error: Directory '$SERVERS_DIR' not found!"
    exit 1
fi

# Get list of subdirectories in servers/
options=($(find "$SERVERS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort))

if [ ${#options[@]} -eq 0 ]; then
    echo "❌ No servers found in '$SERVERS_DIR'."
    exit 1
fi

# Get system info
HOST_NAME=$(hostname)
OS_INFO=$(uname -sm)
CURRENT_USER=$(whoami)

echo "🔧 Action: $COMMAND"
echo "💻 System: $HOST_NAME ($OS_INFO) | User: $CURRENT_USER"
echo "🚀 Select a server:"
echo "---------------------------"

# Display menu
for i in "${!options[@]}"; do
    echo "$((i+1)). ${options[$i]}"
done

echo "---------------------------"
read -p "Enter number (1-${#options[@]}): " choice

# Validate input
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#options[@]}" ]; then
    echo "❌ Invalid selection."
    exit 1
fi

# Get selected server name
selected_server="${options[$((choice-1))]}"
target_dir="$SERVERS_DIR/$selected_server"

echo ""
echo "🔥 Running '$COMMAND' on: $selected_server"
echo "📂 Path: $target_dir"
echo "---------------------------"

cd "$target_dir" || exit 1

# Execute command based on priority: Makefile > Docker Compose
if [ -f "Makefile" ]; then
    # If Makefile exists, check if it has the target, otherwise fallback to generic docker compose
    if grep -q "^$COMMAND:" Makefile; then
        make "$COMMAND"
    else
        echo "⚠️  Makefile found but target '$COMMAND' missing. Falling back to Docker Compose."
        case $COMMAND in
            deploy) 
                echo "📥 Pulling latest images..."
                docker compose pull
                echo "🚀 Starting services (recreating only changed containers)..."
                docker compose up -d --remove-orphans
                ;;
            down)   docker compose down ;;
            config) docker compose config ;;
            prune)  docker image prune -f ;;
            clean)  docker compose down --rmi all ;;
            *)      echo "❌ Unknown command for fallback: $COMMAND"; exit 1 ;;
        esac
    fi
elif [ -f "docker-compose.yml" ]; then
    echo "⚠️  No Makefile found. Running direct docker compose..."
    case $COMMAND in
        deploy) 
            echo "📥 Pulling latest images..."
            docker compose pull
            echo "🚀 Starting services (recreating only changed containers)..."
            docker compose up -d --remove-orphans
            ;;
        down)   docker compose down ;;
        config) docker compose config ;;
        prune)  docker image prune -f ;;
        clean)  docker compose down --rmi all ;;
        *)      echo "❌ Unknown command: $COMMAND"; exit 1 ;;
    esac
else
    echo "❌ No configuration found in $target_dir"
    exit 1
fi
