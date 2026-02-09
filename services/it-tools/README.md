# 🛠️ IT-Tools - Developer Tools Collection

**IT-Tools** is a collection of handy online tools for developers with great UX, all running locally in your HomeLab.

## 📋 Overview

- **Purpose**: Self-hosted developer utilities and converters
- **Web UI**: Modern, intuitive interface
- **Platform**: `linux/arm64` compatible (Raspberry Pi optimized)
- **Privacy**: All processing happens client-side in browser

## 🚀 Features

### Crypto & Security
- ✅ Hash generators (MD5, SHA1, SHA256, SHA512)
- ✅ UUID/GUID generator
- ✅ Bcrypt hash generator
- ✅ Password strength analyzer
- ✅ RSA key pair generator
- ✅ Encryption/Decryption tools

### Encoders & Decoders
- ✅ Base64 encode/decode
- ✅ URL encode/decode
- ✅ HTML entities encode/decode
- ✅ JWT decoder
- ✅ QR code generator
- ✅ Barcode generator

### Text & String Tools
- ✅ String case converter
- ✅ Text diff checker
- ✅ Lorem ipsum generator
- ✅ Markdown preview
- ✅ String length calculator
- ✅ Text to ASCII art

### Converters
- ✅ JSON to YAML
- ✅ JSON to CSV
- ✅ XML to JSON
- ✅ Color converter (HEX, RGB, HSL)
- ✅ Unix timestamp converter
- ✅ Number base converter

### Network & Web
- ✅ IP address lookup
- ✅ User agent parser
- ✅ URL parser
- ✅ MIME types lookup
- ✅ HTTP status codes
- ✅ Port scanner info

### Data & Math
- ✅ JSON formatter/validator
- ✅ SQL formatter
- ✅ Math evaluator
- ✅ Percentage calculator
- ✅ Random number generator
- ✅ Statistics calculator

## ⚙️ Configuration

No configuration required! IT-Tools is stateless and works out of the box.

### Ports

- **8091/tcp** - Web UI access

## 🌐 Access

Navigate to `http://<raspi5-ip>:8091`

## 📱 Usage

### Quick Start

1. Open IT-Tools in your browser
2. Browse available tools by category
3. Select a tool from the sidebar
4. Use the tool (all processing happens in browser)

### Popular Tools

**Hash Generator**
- Enter text
- Select hash algorithm
- Copy generated hash

**Base64 Encoder**
- Paste text or upload file
- Click encode/decode
- Copy result

**JSON Formatter**
- Paste JSON
- Auto-format and validate
- Copy formatted output

**QR Code Generator**
- Enter text or URL
- Customize size and error correction
- Download QR code image

## 🛠️ Management

### View Logs

```bash
docker logs it-tools
docker logs -f it-tools  # Follow logs
```

### Restart Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose restart it-tools
```

### Update Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose pull it-tools
docker compose up -d it-tools
```

## 💾 Data Persistence

IT-Tools is **stateless** - all processing happens in your browser:
- No data stored on server
- No configuration needed
- No volumes required
- Complete privacy

## 🔒 Security Best Practices

### Essential Security

- ✅ **Client-Side Processing**: All operations happen in browser
- ✅ **No Data Transmission**: Nothing sent to server
- ✅ **Local Network**: Safe to use on local network
- ✅ **No Authentication Needed**: Stateless design

### Advanced Security

- Use reverse proxy for HTTPS if exposing externally
- Implement IP whitelisting if needed
- Monitor access logs for unusual activity

## 🔧 Troubleshooting

### Service Not Accessible

1. **Check container status**: `docker ps | grep it-tools`
2. **Verify port binding**: `docker port it-tools`
3. **Check logs**: `docker logs it-tools --tail 50`

### Tool Not Working

1. **Check browser console**: Look for JavaScript errors
2. **Clear browser cache**: Force refresh (Ctrl+F5)
3. **Try different browser**: Ensure modern browser support

## 📊 Resource Usage

- **CPU**: Minimal (client-side processing)
- **Memory**: ~50MB (very lightweight)
- **Storage**: Minimal (no data persistence)

## 🎯 Use Cases

### Development

- Generate UUIDs for database records
- Hash passwords for testing
- Format and validate JSON/YAML
- Convert between data formats

### DevOps

- Encode/decode Base64 secrets
- Parse JWT tokens
- Convert Unix timestamps
- Analyze user agents

### Security

- Generate strong passwords
- Create RSA key pairs
- Hash sensitive data
- Encrypt/decrypt text

### General Utilities

- Generate QR codes
- Convert colors between formats
- Create Lorem ipsum text
- Calculate percentages

## 📝 Notes

- **No Backend**: All tools run in browser (JavaScript)
- **Privacy First**: No data leaves your browser
- **Offline Capable**: Works without internet after initial load
- **Fast**: No server processing delays
- **Mobile Friendly**: Responsive design

## 🔗 Resources

- [GitHub Repository](https://github.com/CorentinTh/it-tools)
- [Docker Hub](https://hub.docker.com/r/corentinth/it-tools)
- [Live Demo](https://it-tools.tech)

## 🌟 Popular Tool Categories

### For Developers
- JSON/YAML/XML converters
- Hash generators
- UUID generators
- Base64 encoder/decoder

### For DevOps
- JWT decoder
- Unix timestamp converter
- IP lookup
- User agent parser

### For Security
- Password generator
- Bcrypt hash
- Encryption tools
- Hash validators

### For Everyone
- QR code generator
- Color converter
- Text case converter
- Lorem ipsum generator
