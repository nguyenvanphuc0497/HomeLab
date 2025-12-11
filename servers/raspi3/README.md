# 🍓 Raspberry Pi 3 - Management Node

**Architecture:** ARMv7 (32-bit)  
**RAM:** 1GB  
**Role:** Management Node (Lightweight Services)  
**OS:** Ubuntu Server LTS

## 📋 Overview

Raspberry Pi 3 serves as a lightweight management node with limited resources. Ideal for:
- Lightweight reverse proxy
- Basic monitoring tools
- Low-resource utilities
- Backup/management scripts

**⚠️ Resource Constraints:** With only 1GB RAM, avoid memory-intensive services. Prefer Alpine-based images and single-container services.

## 🏗️ Architecture

- **Platform:** `linux/arm/v7` (32-bit ARM)
- **CPU:** ARM Cortex-A53 (quad-core, 1.2GHz)
- **Storage:** MicroSD card (recommend Class 10+ or SSD via USB)

## 🚀 Setup

### 1. Prerequisites

```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker compose version
```

### 2. Environment Configuration

```bash
cd servers/raspi3
cp env.example .env
nano .env  # Edit with your values
```

**Required Variables:**
```bash
HOSTNAME=raspi3
TZ=Asia/Ho_Chi_Minh
DOMAIN_SUFFIX=.lan
DATA_ROOT=/srv/homelab/raspi3  # Adjust path as needed
PUID=1000                       # Your user ID
PGID=1000                       # Your group ID
UMASK=002
```

### 3. Deploy

```bash
make check   # Validate configuration
make deploy  # Pull images and start services
```

## 📦 Recommended Services

Due to resource constraints, consider:

- **Caddy** or **Traefik** (lightweight reverse proxy)
- **Uptime Kuma** (monitoring, if resources allow)
- **Watchtower** (auto-update containers)
- **Portainer** (Docker UI, optional)

Avoid:
- Media servers (Plex/Jellyfin)
- Database-heavy applications
- Multiple simultaneous services

## 🛠️ Management Commands

```bash
make logs      # View logs
make ps        # Check running containers
make restart   # Restart all services
make down      # Stop services
```

## 🔧 Troubleshooting

### Out of Memory

If containers crash or OOM errors occur:

1. Check memory usage:
   ```bash
   free -h
   docker stats
   ```

2. Reduce service count or use lighter images
3. Consider disabling swap or adding swap file:
   ```bash
   sudo fallocate -l 1G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

### Slow Performance

- Use Alpine-based images (smaller, faster)
- Limit container resource usage in compose:
  ```yaml
  deploy:
    resources:
      limits:
        memory: 256M
  ```

## 📝 Notes

- This node may be phased out or repurposed as newer Pis are added
- Consider migrating services to Raspi 4/5 for better performance
- Keep services minimal to maintain stability

---

**See also:** [`../README.md`](../README.md) for general server management guide.

