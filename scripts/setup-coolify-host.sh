#!/bin/bash

# Coolify Host Setup Script
# This script prepares the host (Raspberry Pi) for Coolify to run via Docker Compose.
# It handles the necessary Host modifications that Docker Compose cannot do (SSH keys, Directories).

echo "🍓 Setting up Coolify Host Prerequisites..."

# Check root
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run as root (sudo ./setup-coolify-host.sh)"
  exit 1
fi

# 1. Create Required Directories (Local project path)
# Assuming script is run from scripts/, so data is in ../services/coolify/data
BASE_DIR="$(dirname "$(dirname "$(realpath "$0")")")/services/coolify/data"
echo "📂 Creating data directories at $BASE_DIR..."
mkdir -p "$BASE_DIR"/{ssh,applications,databases,services,backups,source}
# Note: In a relative path setup on Mac/Linux, ownership management is trickier.
# ideally we want the container user (UID 9999) to read it.
# For simplicity in HomeLab, we allow flexible permissions or rely on Docker to manage owner.
chmod -R 777 "$BASE_DIR" 2>/dev/null || chmod -R 700 "$BASE_DIR"

# 2. Generate SSH Key for Localhost Access (Coolify controls Docker via SSH)
echo "🔑 Configuring SSH Keys for Coolify Loopback..."

SSH_KEY_DIR="$BASE_DIR/ssh/keys"
mkdir -p "$SSH_KEY_DIR"

# Check if key already exists to avoid overwriting
if [ ! -f "$SSH_KEY_DIR/id.root@host.docker.internal" ]; then
    echo "   - Generating new ED25519 key..."
    ssh-keygen -t ed25519 -a 100 -f "$SSH_KEY_DIR/id.root@host.docker.internal" -q -N "" -C coolify
    chown 9999 "$SSH_KEY_DIR/id.root@host.docker.internal"
    
    # Add public key to host's authorized_keys
    echo "   - Authorizing key for root usage..."
    cat "$SSH_KEY_DIR/id.root@host.docker.internal.pub" >> /root/.ssh/authorized_keys
    rm -f "$SSH_KEY_DIR/id.root@host.docker.internal.pub"
    chmod 600 /root/.ssh/authorized_keys
else
    echo "   - SSH Key already exists, skipping."
fi

echo "✅ Host Setup Complete!"
echo "👉 Now you can run 'make deploy' to start Coolify via Docker Compose."
