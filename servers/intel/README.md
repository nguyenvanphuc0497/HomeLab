# 💻 Intel NUC - Virtualization Host

**Architecture:** x86_64 (AMD64)  
**RAM:** 8GB  
**Role:** Virtualization Host (Proxmox VE)  
**OS:** Proxmox VE

## 📋 Overview

Intel NUC runs **Proxmox VE** for virtualization. This directory contains Docker Compose configurations for services running **within VMs** on the NUC, or for the Proxmox host itself if Docker is installed.

**Note:** Most services run in VMs (Home Assistant OS, Windows), not directly in Docker on the host. This compose file is for host-level services or VM management tools.

## 🏗️ Architecture

- **Platform:** `linux/amd64` (64-bit x86)
- **CPU:** Intel Core i5 (varies by model)
- **Hypervisor:** Proxmox VE (KVM/QEMU)
- **Storage:** Internal SSD + optional external storage

## 🚀 Setup

### 1. Prerequisites

If using Docker on Proxmox host (not recommended, prefer VMs):

```bash
# Install Docker on Proxmox (if needed)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

**Recommended:** Run Docker services in **LXC containers** or dedicated VMs instead of on the Proxmox host.

### 2. Environment Configuration

```bash
cd servers/intel-nuc
cp env.example .env
nano .env  # Edit with your values
```

**Required Variables:**
```bash
HOSTNAME=intel-nuc
TZ=Asia/Ho_Chi_Minh
DOMAIN_SUFFIX=.lan
DATA_ROOT=/var/lib/docker/data  # Or /mnt/storage
PUID=0  # root (or create docker user)
PGID=0
UMASK=022
```

### 3. Deploy

```bash
make check   # Validate configuration
make deploy  # Pull images and start services
```

## 📦 Typical Services

### Proxmox Host Services (if using Docker)

- **Proxmox Exporter** - Prometheus metrics exporter
- **Backup Tools** - Automated backup scripts
- **Monitoring Agents** - Node exporter, etc.

### VM-Based Services (configured elsewhere)

- **Home Assistant OS** - Smart home automation (VM)
- **Windows VM** - Desktop/workstation (VM)
- **Docker Host VM** - Dedicated VM for containers (optional)

## 🖥️ Proxmox VM Management

### Create VM for Docker Services

1. **Create VM:**
   - Download Ubuntu Server ISO
   - Create VM in Proxmox (2GB RAM, 20GB disk minimum)
   - Install Ubuntu Server

2. **Install Docker:**
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

3. **Deploy Services:**
   - Use this compose file structure in the VM
   - Or create separate VM-specific compose files

### Home Assistant OS (VM)

- Deploy via Proxmox template or ISO
- Configuration stored in VM disk (backup regularly)
- Access via `http://nuc-ip:8123`

## 🔄 CI/CD Integration

GitHub Actions runner can deploy to NUC VMs via:

1. SSH to Proxmox host
2. Use `qm` commands to manage VMs
3. Or SSH directly to VMs for Docker deployments

**Example workflow:**
```yaml
- name: Deploy to NUC VM
  run: |
    ssh user@intel-nuc "cd /path/to/compose && make deploy"
```

## 🛠️ Management Commands

```bash
make logs      # View logs
make ps        # Check running containers
make restart   # Restart services
make down      # Stop services
```

**Proxmox Commands (on host):**
```bash
# List VMs
qm list

# Start/stop VM
qm start <vmid>
qm stop <vmid>

# Backup VM
vzdump <vmid> --storage local
```

## 💾 Storage Management

### Proxmox Storage

- **Local:** VM disks, ISO images
- **Backup:** Regular VM snapshots and backups
- **External:** Mount NFS/SMB for backups

### Docker Data (if used)

- Store in `/var/lib/docker` (default)
- Or mount external storage for large datasets

## 🔧 Troubleshooting

### VM Performance Issues

1. Check resource allocation:
   ```bash
   qm config <vmid>
   ```

2. Monitor host resources:
   ```bash
   htop
   df -h
   ```

3. Adjust VM CPU/RAM if needed

### Docker on Proxmox Host

**Not Recommended:** Prefer running Docker in VMs or LXC containers for isolation.

If you must use Docker on host:
- Keep services minimal
- Monitor resource usage
- Use resource limits

### Network Issues

- Ensure VM network bridge is configured correctly
- Check firewall rules in Proxmox
- Verify VM network settings

## 🔒 Security Considerations

- **Proxmox Access:** Use strong passwords, enable 2FA
- **VM Isolation:** Keep VMs isolated from host
- **Backups:** Regular automated backups of critical VMs
- **Updates:** Keep Proxmox and VMs updated

## 📝 Best Practices

1. **Use VMs for Services:** Don't run Docker directly on Proxmox host
2. **Resource Allocation:** Reserve resources for Proxmox itself
3. **Backup Strategy:** Automated VM backups to external storage
4. **Monitoring:** Monitor VM health and resource usage

## 🎯 Future Enhancements

- **High Availability:** Cluster multiple Proxmox nodes
- **Ceph Storage:** Distributed storage for VMs
- **ZFS:** Use ZFS for snapshots and compression
- **GPU Passthrough:** For media transcoding VMs

---

**See also:** [`../README.md`](../README.md) for general server management guide.

