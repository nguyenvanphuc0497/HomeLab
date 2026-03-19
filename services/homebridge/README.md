# Homebridge

![Homebridge](https://github.com/homebridge/branding/raw/latest/logos/homebridge-wordmark-logo-vertical.png)

**HomeKit support for the impatient** - Integrate non-HomeKit smart home devices with Apple HomeKit.

## 📋 Overview

Homebridge allows you to integrate smart home devices that do not natively support Apple HomeKit. It creates a bridge between your devices and HomeKit, enabling control through the Home app, Siri, and automation.

## 🚀 Features

- **Apple HomeKit Integration**: Control devices via Home app and Siri
- **Plugin Ecosystem**: 2000+ plugins for various smart home devices
- **Web UI**: Easy configuration via browser at `http://<server-ip>:8581`
- **Automation**: Create HomeKit scenes and automations
- **Multi-Platform**: Works with iOS, iPadOS, macOS, watchOS, tvOS

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TZ` | `UTC` | Timezone (e.g., `Asia/Ho_Chi_Minh`) |
| `ENABLE_AVAHI` | `1` | Enable mDNS for HomeKit discovery |

### Ports

| Port | Protocol | Description |
|------|----------|-------------|
| `8581` | HTTP | Homebridge Web UI |
| `51826` | TCP | HomeKit communication |

**Note**: This service uses `network_mode: host` for HomeKit mDNS discovery.

### Volumes

| Path | Description |
|------|-------------|
| `./data` | Homebridge configuration, plugins, and accessories |

## 📱 Setup

### 1. Start the Service

```bash
docker compose up -d
```

### 2. Access Web UI

Open browser: `http://<raspberry-pi-ip>:8581`

**Default credentials:**
- Username: `admin`
- Password: `admin`

⚠️ **Change the default password immediately!**

### 3. Add to HomeKit

1. Open **Home** app on iPhone/iPad
2. Tap **+** → **Add Accessory**
3. Scan the QR code shown in Homebridge UI
4. Or enter the 8-digit PIN manually

### 4. Install Plugins

Browse and install plugins from the Web UI:
- **Plugins** tab → Search for your device brand
- Click **Install**
- Configure in **Settings** tab

## 🔌 Popular Plugins

| Plugin | Description |
|--------|-------------|
| [homebridge-config-ui-x](https://github.com/homebridge/homebridge-config-ui-x) | Web UI (pre-installed) |
| [homebridge-camera-ffmpeg](https://github.com/Sunoo/homebridge-camera-ffmpeg) | Camera support |
| [homebridge-ring](https://github.com/dgreif/ring) | Ring devices |
| [homebridge-hue](https://github.com/ebaauw/homebridge-hue) | Philips Hue |
| [homebridge-tuya](https://github.com/iRayanKhan/homebridge-tuya) | Tuya/Smart Life devices |

Browse all plugins: https://www.npmjs.com/search?q=homebridge-plugin

## 🛠️ Troubleshooting

### Can't find Homebridge in Home app

1. Ensure iPhone/iPad is on the same network
2. Check Homebridge is running: `docker ps | grep homebridge`
3. Verify mDNS is working: `docker logs homebridge | grep Avahi`
4. Try manual pairing with PIN code

### Web UI not accessible

```bash
# Check container status
docker logs homebridge

# Verify port 8581 is listening
curl http://localhost:8581
```

### Reset Homebridge

```bash
# Stop and remove data
docker compose down
rm -rf ./data

# Start fresh
docker compose up -d
```

## 📚 Resources

- **Official Website**: https://homebridge.io
- **Documentation**: https://github.com/homebridge/homebridge/wiki
- **Plugin Directory**: https://www.npmjs.com/search?q=homebridge-plugin
- **Discord Community**: https://discord.gg/homebridge
- **Reddit**: https://www.reddit.com/r/homebridge

## 🔐 Security Notes

- Change default Web UI password immediately
- Use strong HomeKit PIN codes
- Keep Homebridge and plugins updated
- Restrict network access if needed

## 📝 Example Configuration

After setup, your `data/config.json` will look like:

```json
{
  "bridge": {
    "name": "Homebridge",
    "username": "XX:XX:XX:XX:XX:XX",
    "port": 51826,
    "pin": "XXX-XX-XXX"
  },
  "accessories": [],
  "platforms": [
    {
      "name": "Config",
      "port": 8581,
      "platform": "config"
    }
  ]
}
```

## 🆘 Support

- Check logs: `docker logs homebridge`
- Visit [Homebridge Discord](https://discord.gg/homebridge)
- Search [GitHub Issues](https://github.com/homebridge/homebridge/issues)
