# 🔒 WG-Easy - WireGuard VPN with Web UI

**WG-Easy** is a simple, web-based interface for managing WireGuard VPN connections. It provides an intuitive dashboard for creating and managing VPN clients without dealing with complex configuration files.

## 📋 Overview

- **Purpose**: Secure remote access to HomeLab network via WireGuard VPN
- **Web UI**: Easy client management with QR codes for mobile devices
- **Platform**: `linux/arm64` compatible (Raspberry Pi optimized)
- **Security**: Modern WireGuard protocol with web-based administration

## 🚀 Features

- ✅ Simple web interface for VPN management
- ✅ QR code generation for mobile clients
- ✅ Traffic statistics and monitoring
- ✅ Multi-client support
- ✅ Automatic client configuration generation
- ✅ No complex command-line configuration needed

## ⚙️ Configuration

### Required Environment Variables

```bash
# Your public IP or domain name (REQUIRED)
WG_HOST=vpn.yourdomain.com  # or your public IP

# Web UI admin password (REQUIRED - change from default!)
WG_ADMIN_PASSWORD=your-secure-password-here
```

### Optional Environment Variables

```bash
# DNS server for VPN clients (default: 1.1.1.1)
WG_DEFAULT_DNS=1.1.1.1

# Timezone (default: UTC)
TZ=UTC

# VPN subnet (default: 10.8.0.x)
# WG_DEFAULT_ADDRESS=10.8.0.x

# MTU size (default: 1420)
# WG_MTU=1420

# Keep-alive interval in seconds (default: 25)
# WG_PERSISTENT_KEEPALIVE=25
```

## 🌐 Network Configuration

### Network Architecture

WG-Easy uses a dedicated Docker network with both IPv4 and IPv6 support:

- **Network Name**: `wg`
- **IPv4 Subnet**: `10.43.43.0/24`
- **IPv6 Subnet**: `fdcc:ad94:bacf:61a4::/64`
- **Container IPv4**: `10.43.43.42`
- **Container IPv6**: `fdcc:ad94:bacf:61a4::2a`

### Ports

- **51820/udp** - WireGuard VPN traffic
- **51821/tcp** - Web UI access

### Router Setup

**Port forwarding required for external VPN access:**

1. Forward UDP port **51820** to your Raspberry Pi 5 IP
2. Optionally forward TCP port **51821** if you want external Web UI access (not recommended for security)

**Recommended**: Only expose port 51820 externally. Access the Web UI via:
- Local network: `http://<raspi5-ip>:51821`
- VPN tunnel: After connecting to VPN, access via internal IP
- Cloudflare Tunnel: Secure external access without port forwarding

## 📱 Client Setup

### Adding a New Client

1. Access Web UI at `http://<raspi5-ip>:51821`
2. Login with your `WG_ADMIN_PASSWORD`
3. Click **"New Client"**
4. Enter client name (e.g., "iPhone", "Laptop")
5. Download configuration or scan QR code

### Mobile Devices (iOS/Android)

1. Install **WireGuard** app from App Store/Play Store
2. Scan QR code from WG-Easy web interface
3. Enable VPN connection

### Desktop/Laptop

1. Install WireGuard client for your OS
2. Download `.conf` file from WG-Easy
3. Import configuration into WireGuard client
4. Connect to VPN

## 🔒 Security Best Practices

### Essential Security

- ✅ **Change default password**: Set strong `WG_ADMIN_PASSWORD`
- ✅ **Restrict Web UI**: Don't expose port 51821 to internet
- ✅ **Use strong client names**: Avoid revealing device information
- ✅ **Regular audits**: Review and remove unused clients

### Advanced Security

- Use Cloudflare Tunnel for Web UI access instead of port forwarding
- Implement fail2ban for Web UI brute-force protection
- Enable 2FA if using reverse proxy with authentication
- Monitor VPN traffic via Prometheus/Grafana

## 🛠️ Management

### View Logs

```bash
docker logs wg-easy
docker logs -f wg-easy  # Follow logs
```

### Restart Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose restart wg-easy
```

### Backup Configuration

```bash
# Backup WireGuard configuration
docker run --rm -v wg-easy_wg_data:/data -v $(pwd):/backup \
  alpine tar czf /backup/wg-easy-backup.tar.gz -C /data .
```

### Restore Configuration

```bash
# Restore from backup
docker run --rm -v wg-easy_wg_data:/data -v $(pwd):/backup \
  alpine tar xzf /backup/wg-easy-backup.tar.gz -C /data
```

## 🔧 Troubleshooting

### Cannot Connect to VPN

1. **Check port forwarding**: Ensure UDP 51820 is forwarded to Raspberry Pi 5
2. **Verify public IP**: Confirm `WG_HOST` matches your actual public IP/domain
3. **Check firewall**: Ensure UFW/iptables allows UDP 51820
4. **Test locally first**: Try connecting from same network before external

```bash
# Check if WireGuard is running
docker exec wg-easy wg show

# Check container logs
docker logs wg-easy --tail 50
```

### Web UI Not Accessible

1. **Check container status**: `docker ps | grep wg-easy`
2. **Verify port binding**: `docker port wg-easy`
3. **Check firewall**: Ensure port 51821 is accessible locally

```bash
# Test Web UI port
curl http://localhost:51821
```

### VPN Connected but No Internet

1. **Check DNS settings**: Verify `WG_DEFAULT_DNS` is set correctly
2. **IP forwarding**: Ensure `net.ipv4.ip_forward=1` is enabled
3. **NAT configuration**: Check router NAT settings

```bash
# Verify IP forwarding
docker exec wg-easy sysctl net.ipv4.ip_forward
```

### Performance Issues

- **Reduce MTU**: Try `WG_MTU=1380` for problematic networks
- **Adjust keepalive**: Increase `WG_PERSISTENT_KEEPALIVE` if behind NAT
- **Check bandwidth**: Monitor with `docker stats wg-easy`

## 📊 Monitoring

### Traffic Statistics

- Built-in traffic stats available in Web UI
- Enable with `UI_TRAFFIC_STATS=true` (enabled by default)

### Integration with Prometheus

WG-Easy doesn't expose Prometheus metrics by default. For monitoring:

1. Use **wireguard-exporter** alongside WG-Easy
2. Monitor container metrics via **cAdvisor**
3. Track connection logs via **Loki**

## 🎯 Use Cases

### Remote Access to HomeLab

- Access internal services (Gitea, Grafana, etc.) securely
- Bypass ISP restrictions and censorship
- Secure connection on public WiFi

### DNS-level Ad Blocking

- Route VPN traffic through Pi-hole for ad blocking
- Set `WG_DEFAULT_DNS` to Pi-hole IP (e.g., `192.168.x.x`)

### Multi-site Connectivity

- Connect multiple locations via VPN
- Create site-to-site VPN tunnels
- Access resources across networks

## 📝 Notes

- **Performance**: WireGuard is very efficient on ARM64 (Raspberry Pi 5)
- **Scalability**: Can handle 10-20 concurrent clients on Pi 5
- **Updates**: Use `docker compose pull` to update to latest version
- **Persistence**: All configuration stored in `wg_data` volume

## 🔗 Resources

- [WG-Easy GitHub](https://github.com/wg-easy/wg-easy)
- [WireGuard Official Site](https://www.wireguard.com/)
- [WireGuard Client Downloads](https://www.wireguard.com/install/)

---

**See also:** [`../../servers/raspi5/README.md`](../../servers/raspi5/README.md) for Raspberry Pi 5 deployment guide.
