# 📄 Stirling PDF - Self-Hosted PDF Tool

**Stirling PDF** is a powerful, locally hosted web-based PDF manipulation tool that allows you to perform various operations on PDF files without uploading them to third-party services.

## 📋 Overview

- **Purpose**: Self-hosted PDF manipulation and conversion
- **Web UI**: Feature-rich interface for PDF operations
- **Platform**: `linux/arm64` compatible (Raspberry Pi optimized)
- **Privacy**: All processing happens locally

## 🚀 Features

- ✅ Merge multiple PDFs
- ✅ Split PDFs by page ranges
- ✅ Rotate pages
- ✅ Convert images to PDF
- ✅ Convert PDF to images
- ✅ Compress PDFs
- ✅ Add/remove passwords
- ✅ Add watermarks
- ✅ Extract pages
- ✅ Rearrange pages
- ✅ OCR (Optical Character Recognition)
- ✅ Sign PDFs
- ✅ Flatten PDFs
- ✅ Repair corrupted PDFs

## ⚙️ Configuration

### Environment Variables

```bash
# Optional: Timezone (default: UTC)
TZ=Asia/Ho_Chi_Minh
```

### Ports

- **8090/tcp** - Web UI access

## 🌐 Access

Navigate to `http://<raspi5-ip>:8090`

## 📱 Usage

### Basic Operations

1. **Merge PDFs**
   - Upload multiple PDF files
   - Arrange in desired order
   - Click "Merge"

2. **Split PDF**
   - Upload PDF
   - Select page ranges
   - Click "Split"

3. **Convert Images to PDF**
   - Upload images (JPG, PNG, etc.)
   - Arrange order
   - Click "Convert"

4. **Compress PDF**
   - Upload PDF
   - Select compression level
   - Click "Compress"

### Advanced Features

- **OCR**: Extract text from scanned documents
- **Sign**: Add digital signatures
- **Watermark**: Add text or image watermarks
- **Password Protection**: Encrypt PDFs with passwords

## 🛠️ Management

### View Logs

```bash
docker logs stirling-pdf
docker logs -f stirling-pdf  # Follow logs
```

### Restart Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose restart stirling-pdf
```

### Update Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose pull stirling-pdf
docker compose up -d stirling-pdf
```

## 💾 Data Persistence

Configuration data is stored in the `stirling_data` volume:
- User preferences
- Custom settings
- Temporary processing files

## 🔒 Security Best Practices

### Essential Security

- ✅ **Local Network Only**: Don't expose to internet without authentication
- ✅ **Reverse Proxy**: Use Nginx/Traefik with authentication if exposing
- ✅ **Regular Updates**: Keep image updated for security patches

### Advanced Security

- Enable authentication via reverse proxy
- Use HTTPS with SSL certificates
- Implement rate limiting
- Monitor access logs

## 🔧 Troubleshooting

### Service Not Accessible

1. **Check container status**: `docker ps | grep stirling-pdf`
2. **Verify port binding**: `docker port stirling-pdf`
3. **Check logs**: `docker logs stirling-pdf --tail 50`

### PDF Processing Fails

1. **Check file size**: Large PDFs may take time
2. **Verify file format**: Ensure valid PDF format
3. **Check logs**: Look for error messages

### Performance Issues

- **Reduce file size**: Compress large PDFs before processing
- **Increase resources**: Allocate more memory if needed
- **Check disk space**: Ensure sufficient storage

## 📊 Resource Usage

- **CPU**: Low to moderate (spikes during processing)
- **Memory**: 256MB - 1GB (depends on PDF size)
- **Storage**: Minimal (only configs and temp files)

## 🎯 Use Cases

### Personal Use

- Merge scanned documents
- Convert photos to PDF
- Compress PDFs for email
- Add signatures to forms

### Business Use

- Process invoices and receipts
- Create document archives
- Prepare documents for printing
- OCR scanned contracts

### Development

- Generate PDFs from images
- Test PDF processing workflows
- Automate document preparation

## 📝 Notes

- **Processing Speed**: Depends on PDF size and operation
- **File Limits**: Can handle large PDFs (tested up to 100MB+)
- **Format Support**: PDF, JPG, PNG, TIFF, and more
- **No Cloud**: All processing happens locally for privacy

## 🔗 Resources

- [Official Documentation](https://docs.stirlingpdf.com/)
- [GitHub Repository](https://github.com/Stirling-Tools/Stirling-PDF)
- [Docker Hub](https://hub.docker.com/r/stirlingtools/stirling-pdf)
