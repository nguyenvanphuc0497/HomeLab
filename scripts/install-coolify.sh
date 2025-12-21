#!/bin/bash

# Coolify Installation Script for Raspberry Pi 5 (Ubuntu/Debian)
# Reference: https://coolify.io/docs/installation

echo "🍓 Setting up Coolify on Raspberry Pi 5..."

# Check root
if [ "$EUID" -ne 0 ]; then 
  echo "❌ Please run as root (sudo ./install-coolify.sh)"
  exit 1
fi

# 1. Prerequisite: SSH Config (Coolify needs SSH access to localhost)
echo "🔑 Configuring SSH for Coolify..."
if [ ! -f /root/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -N "" -q
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

# 2. Install Coolify
echo "🚀 One-click installing Coolify..."
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash

echo "✅ Coolify installation initiated!"
echo "⏳ It may take a few minutes to start."
echo "🌍 Access Dashboard at: http://$(hostname -I | awk '{print $1}'):8000"
