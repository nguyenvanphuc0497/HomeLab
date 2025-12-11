# 🖥️ AMD OVM - Virtualization Host

**Architecture:** x86_64 (AMD64)  
**RAM:** Varies  
**Role:** Virtualization Host (OVM/Proxmox)  
**OS:** Proxmox VE or OVM

## 📋 Overview

AMD-based virtualization host running Proxmox VE or Oracle VM (OVM). Similar to Intel NUC but with AMD CPU architecture. This directory contains Docker Compose configurations for host-level services or VM management tools.

**Note:** Most services run in VMs, not directly in Docker on the host. This compose file is for host-level services or VM management tools.

## 🏗️ Architecture

- **Platform:** `linux/amd64` (64-bit x86)
- **CPU:** AMD (varies by model)
- **Hypervisor:** Proxmox VE or OVM (KVM/QEMU)
- **Storage:** Internal storage + optional external

## 🚀 Setup

### 1. Prerequisites

If using Docker on virtualization host:

```bash
# Install Docker (if not using VMs)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

**Recommended:** Run Docker services in **dedicated VMs** or LXC containers for better isolation.

### 2. Environment Configuration

```bash
cd servers/amd-ovm
cp env.example .env
nano .env  # Edit with your values
```

**Required Variables:**
```bash
HOSTNAME=amd-ovm
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

### Host Services (if using Docker)

- **Proxmox Exporter** - Prometheus metrics exporter
- **Backup Tools** - Automated backup scripts
- **Monitoring Agents** - Node exporter, etc.

### VM-Based Services

- **Development VMs** - Various Linux/Windows VMs
- **Testing Environments** - Isolated test VMs
- **Docker Host VMs** - Dedicated VMs for container workloads

## 🖥️ VM Management

### Proxmox VE

If running Proxmox VE:

```bash
# List VMs
qm list

# Start/stop VM
qm start <vmid>
qm stop <vmid>

# Backup VM
vzdump <vmid> --storage local
```

### Oracle VM (OVM)

If running OVM, use OVM Manager or CLI tools for VM management.

## 🔄 CI/CD Integration

GitHub Actions runner can deploy to AMD OVM VMs via:

1. SSH to virtualization host
2. Use hypervisor commands to manage VMs
3. Or SSH directly to VMs for Docker deployments

**Example workflow:**
```yaml
- name: Deploy to AMD OVM VM
  run: |
    ssh user@amd-ovm "cd /path/to/compose && make deploy"
```

## 🛠️ Management Commands

```bash
make logs      # View logs
make ps        # Check running containers
make restart   # Restart services
make down      # Stop services
```

## 💾 Storage Management

### Virtualization Storage

- **Local:** VM disks, ISO images
- **Backup:** Regular VM snapshots and backups
- **External:** Mount NFS/SMB for backups

### Docker Data (if used)

- Store in `/var/lib/docker` (default)
- Or mount external storage for large datasets

## 🔧 Troubleshooting

### VM Performance Issues

1. Check resource allocation in hypervisor
2. Monitor host resources (CPU, RAM, disk I/O)
3. Adjust VM CPU/RAM allocation if needed

### AMD-Specific Considerations

- **IOMMU:** Enable in BIOS for GPU passthrough
- **CPU Features:** Verify virtualization extensions enabled
- **Compatibility:** Some older AMD CPUs may have limitations

### Network Issues

- Ensure VM network bridge is configured correctly
- Check firewall rules
- Verify VM network settings

## 🔒 Security Considerations

- **Hypervisor Access:** Use strong passwords, enable 2FA
- **VM Isolation:** Keep VMs isolated from host
- **Backups:** Regular automated backups of critical VMs
- **Updates:** Keep hypervisor and VMs updated

## 📝 Best Practices

1. **Use VMs for Services:** Don't run Docker directly on hypervisor host
2. **Resource Allocation:** Reserve resources for hypervisor itself
3. **Backup Strategy:** Automated VM backups to external storage
4. **Monitoring:** Monitor VM health and resource usage

## 🎯 Future Enhancements

- **High Availability:** Cluster multiple virtualization hosts
- **Distributed Storage:** Ceph or similar for VM storage
- **GPU Passthrough:** For compute-intensive VMs
- **Container Orchestration:** Deploy K3s/K8s in VMs

---

**See also:** [`../README.md`](../README.md) for general server management guide.

