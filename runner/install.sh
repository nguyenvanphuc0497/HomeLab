#!/bin/bash

# GitHub Actions Runner Setup Script for Raspberry Pi (Linux ARM64)
# Usage: ./install.sh <REPO_URL> <RUNNER_TOKEN> <RUNNER_NAME>

REPO_URL=$1
TOKEN=$2
RUNNER_NAME=${3:-"homelab-runner"}
RUNNER_VERSION="2.311.0"

if [ -z "$REPO_URL" ] || [ -z "$TOKEN" ]; then
    echo "Usage: ./install.sh <REPO_URL> <RUNNER_TOKEN> [RUNNER_NAME]"
    exit 1
fi

echo "🚀 Setting up GitHub Actions Runner: $RUNNER_NAME"
echo "📂 Working directory: $(pwd)"

# Create a folder
mkdir -p actions-runner && cd actions-runner

# Download the latest runner package
echo "⬇️  Downloading runner package v${RUNNER_VERSION}..."
curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

# Extract the installer
echo "📦 Extracting..."
tar xzf ./actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

# Create key config
echo "⚙️  Configuring runner..."
./config.sh --url "${REPO_URL}" --token "${TOKEN}" --name "${RUNNER_NAME}" --labels "self-hosted,arm64,raspi" --unattended --replace

# Install as service
echo "🔧 Installing systemd service..."
sudo ./svc.sh install

echo "✅ Setup complete! Run the following command to start the runner:"
echo "     cd actions-runner && sudo ./svc.sh start"
echo ""
echo "To check status:"
echo "     sudo ./svc.sh status"
