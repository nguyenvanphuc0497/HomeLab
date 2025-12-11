# 🍓 Raspberry Pi 5 - Compute Node

**Architecture:** ARM64 (64-bit)  
**RAM:** 4GB  
**Role:** Production Compute Node  
**OS:** Ubuntu Server LTS

## 📋 Overview

Raspberry Pi 5 is the **primary compute node** for production workloads. It hosts user-facing services and media applications:

- **Media Servers** - Plex, Jellyfin, or similar
- **Download Clients** - qBittorrent, Transmission
- **File Management** - Filebrowser, Samba
- **Productivity Tools** - Nextcloud, Calibre
- **Self-hosted Apps** - Various Docker services

## 🏗️ Architecture

- **Platform:** `linux/arm64` (64-bit ARM)
- **CPU:** ARM Cortex-A76 (quad-core, 2.4GHz) - **Significantly faster than Pi 4**
- **Storage:** USB SSD (highly recommended for media storage)
- **Performance:** Can handle multiple concurrent services

## 🚀 Setup

### 1. Prerequisites

```bash
# Ensure Docker and Docker Compose are installed
docker --version
docker compose version

# Verify sufficient storage (media files need space!)
df -h
```

### 2. Environment Configuration

```bash
cd servers/raspi5
cp env.example .env
nano .env  # Edit with your values
```

**Required Variables:**
```bash
HOSTNAME=raspi5
TZ=Asia/Ho_Chi_Minh
DOMAIN_SUFFIX=.lan
DATA_ROOT=/srv/homelab/raspi5  # Or /mnt/usb-ssd/homelab
PUID=1000
PGID=1000
UMASK=002
```

**Media-Specific Variables (add as needed):**
```bash
MEDIA_ROOT=/mnt/usb-ssd/media
TORRENTS_DIR=/mnt/usb-ssd/torrents
```

### 3. Deploy

```bash
make check   # Validate configuration
make deploy  # Pull images and start services
```

## 📦 Recommended Services

### Media Stack

- **Jellyfin** - Media server (open-source, ARM64 optimized)
- **qBittorrent** - Torrent client with web UI
- **Radarr/Sonarr** - Media management automation
- **Prowlarr** - Indexer manager

### File Services

- **Filebrowser** - Web-based file manager
- **Samba** - SMB/CIFS shares for Windows/Mac
- **SFTP** - Secure file transfer

### Self-hosted Apps

- **Nextcloud** - File sync and sharing
- **Calibre** - E-book library
- **Homepage** - Service dashboard
- **Uptime Kuma** - Uptime monitoring

## 🔄 Deployment via CI/CD

This node is typically deployed **via GitHub Actions**:

1. Push changes to `main` branch
2. GitHub Actions triggers workflow
3. Self-hosted runner (on Pi4) SSH to Pi5
4. Runner executes: `cd servers/raspi5 && make deploy`

**Manual Deployment:**
```bash
cd servers/raspi5
make pull    # Update images
make up      # Start/update services
```

## 🛠️ Management Commands

```bash
make logs      # View logs (all services)
make logs SERVICE=service-name  # Specific service
make ps        # Check running containers
make restart   # Restart all services
make down      # Stop services
```

## 💾 Storage Management

### USB SSD Setup (Recommended)

1. Format USB drive:
   ```bash
   sudo fdisk /dev/sda  # Adjust device
   sudo mkfs.ext4 /dev/sda1
   ```

2. Mount permanently:
   ```bash
   sudo mkdir -p /mnt/usb-ssd
   echo "/dev/sda1 /mnt/usb-ssd ext4 defaults 0 2" | sudo tee -a /etc/fstab
   sudo mount -a
   ```

3. Update `DATA_ROOT` in `.env` to use USB path

### Disk Space Monitoring

```bash
# Check usage
df -h

# Find large files
du -sh ${DATA_ROOT}/* | sort -h

# Clean Docker (careful!)
docker system prune -a  # Removes unused images
```

## 🔧 Troubleshooting

### High CPU Usage

1. Check resource usage:
   ```bash
   docker stats
   htop
   ```

2. Limit container resources in compose:
   ```yaml
   deploy:
     resources:
       limits:
         cpus: '2.0'
         memory: 2G
   ```

### Media Transcoding Issues

- Pi5 can handle **light transcoding** (1-2 streams)
- For heavy transcoding, use hardware acceleration or pre-encode
- Consider Jellyfin with hardware acceleration enabled

### Network Performance

- Use **Gigabit Ethernet** (Pi5 has built-in Gigabit)
- Avoid WiFi for media streaming
- Check network speed: `iperf3 -c <server>`

### Container Startup Failures

1. Check logs:
   ```bash
   make logs
   docker logs <container-name>
   ```

2. Verify environment variables:
   ```bash
   docker compose config
   ```

3. Check file permissions:
   ```bash
   ls -la ${DATA_ROOT}
   # Ensure PUID/PGID match actual user
   ```

## 🔒 Security Considerations

- **Exposed Ports:** Only expose necessary ports via reverse proxy
- **Media Access:** Use authentication (Jellyfin users, Samba credentials)
- **Updates:** Keep containers updated (`watchtower` or manual)
- **Backups:** Regular backups of `${DATA_ROOT}` (media files optional)

## 📝 Performance Tips

- **Use USB SSD** for media storage (much faster than SD card)
- **Prefer ARM64 images** - Better performance than multi-arch
- **Limit concurrent services** - Monitor RAM usage
- **Use resource limits** - Prevent one service from starving others

## 🎯 Future Enhancements

- Add **NVMe SSD** via PCIe adapter (Pi5 supports PCIe)
- Cluster with additional Pi5s (Docker Swarm/K3s)
- Offload transcoding to Intel NUC (if needed)

---

**See also:** [`../README.md`](../README.md) for general server management guide.

