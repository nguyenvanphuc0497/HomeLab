# Coolify Setup Guide

**Coolify** is our chosen unified dashboard for deploying services (Gitea, Immich, etc.) on the Raspberry Pi 5. It replaces manual Docker Compose management with a powerful UI.

## 📥 Installation

Because Coolify is now integrated into our IaC stucture, we use a hybrid approach:

1.  **Prepare Host (One-time):**
    Run this script to create SSH keys and folders required by Coolify.
    ```bash
    cd ~/HomeLab/scripts
    sudo ./setup-coolify-host.sh
    ```

2.  **Deploy Stack:**
    Use our standard deployment command. This starts Coolify along with other services defined in `servers/raspi5`.
    ```bash
    cd ~/HomeLab/servers/raspi5
    make deploy
    ```

Wait a few minutes, then open your browser: `http://<IP-RASPI-5>:8000`.

## ⚙️ Configuration

### 1. Create Admin Account
Follow the on-screen prompt to create your admin user.

### 2. Connect GitHub
1.  Go to **Keys & Tokens**.
2.  Add a GitHub Private Key (Deploy Key) or generate a new one and add it to your GitHub Repo settings.
3.  Go to **Sources** -> **Git Sources** -> Add GitHub.

### 3. Deploy a Resource
1.  Go to **Resources** -> **Add New**.
2.  Select **Git Repository** (Public or Private).
3.  Choose this repo (`nguyenvanphuc0497/HomeLab`).
4.  Coolify will auto-detect `docker-compose.yml`.
5.  Click **Deploy**.

## ☁️ Expose to Internet (Cloudflare Tunnel)
Since we have Cloudflare Tunnel setup (Roadmap item):
1.  In Coolify resource settings, go to **Domains**.
2.  Enter `https://gitea.yourdomain.com`.
3.  Coolify will handle the internal proxying.
4.  Ensure your Cloudflare Tunnel routes that domain to Coolify's proxy port.
