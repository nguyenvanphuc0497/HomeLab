# ✏️ Excalidraw - Virtual Whiteboard

**Excalidraw** is an open-source virtual whiteboard for sketching hand-drawn like diagrams. Perfect for wireframes, flowcharts, and collaborative brainstorming.

## 📋 Overview

- **Purpose**: Self-hosted virtual whiteboard and diagramming tool
- **Web UI**: Intuitive hand-drawn style interface
- **Platform**: `linux/arm64` compatible (Raspberry Pi optimized)
- **Privacy**: Local-first with browser storage

## 🚀 Features

### Drawing Tools
- ✅ Rectangle, circle, diamond shapes
- ✅ Arrows with labels
- ✅ Free-hand drawing
- ✅ Text annotations
- ✅ Image support
- ✅ Shape libraries

### Collaboration
- ✅ Real-time collaboration (when enabled)
- ✅ Shareable links
- ✅ End-to-end encryption
- ✅ Live cursors

### Functionality
- ✅ Infinite canvas
- ✅ Dark mode support
- ✅ Zoom and pan
- ✅ Undo/Redo
- ✅ Arrow binding
- ✅ Grid and snap

### Export Options
- ✅ Export to PNG
- ✅ Export to SVG
- ✅ Export to clipboard
- ✅ Save as .excalidraw file
- ✅ Export to JSON

## ⚙️ Configuration

No configuration required! Excalidraw works out of the box.

### Ports

- **8092/tcp** - Web UI access

## 🌐 Access

Navigate to `http://<raspi5-ip>:8092`

## 📱 Usage

### Quick Start

1. Open Excalidraw in your browser
2. Start drawing with tools from left sidebar
3. Drawings auto-save to browser storage
4. Export when finished

### Basic Drawing

**Create Shapes**
- Select shape tool (rectangle, circle, etc.)
- Click and drag on canvas
- Resize and rotate as needed

**Draw Arrows**
- Select arrow tool
- Click start point, drag to end point
- Bind to shapes for automatic connection
- Add labels by double-clicking arrow

**Add Text**
- Select text tool
- Click on canvas
- Type your text
- Customize font and size

**Free Drawing**
- Select pen tool
- Draw freehand on canvas
- Adjust stroke width and color

### Advanced Features

**Layers and Grouping**
- Select multiple elements (Shift+Click)
- Group elements (Ctrl+G)
- Send to back/front
- Lock elements

**Libraries**
- Use built-in shape libraries
- Create custom libraries
- Import community libraries
- Save frequently used shapes

**Collaboration**
- Click "Live collaboration" button
- Share generated link
- Collaborate in real-time
- See others' cursors

## 🛠️ Management

### View Logs

```bash
docker logs excalidraw
docker logs -f excalidraw  # Follow logs
```

### Restart Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose restart excalidraw
```

### Update Service

```bash
cd /path/to/homelab/servers/raspi5
docker compose pull excalidraw
docker compose up -d excalidraw
```

## 💾 Data Persistence

Excalidraw uses **browser local storage**:
- Drawings auto-save to browser
- No server-side storage needed
- Export to `.excalidraw` files for backup
- Import files to restore drawings

### Backup Your Work

1. **Export Individual Drawings**
   - File → Save as → .excalidraw
   - Store files in your preferred location

2. **Export to PNG/SVG**
   - File → Export image
   - Choose format and quality
   - Download to local storage

## 🔒 Security Best Practices

### Essential Security

- ✅ **Local Storage**: Data stored in browser only
- ✅ **No Server Storage**: Nothing persisted on server
- ✅ **Collaboration Encryption**: End-to-end encrypted when sharing
- ✅ **Local Network**: Safe for internal use

### Advanced Security

- Use reverse proxy for HTTPS if exposing externally
- Implement authentication via reverse proxy
- Regular backups of important drawings

## 🔧 Troubleshooting

### Service Not Accessible

1. **Check container status**: `docker ps | grep excalidraw`
2. **Verify port binding**: `docker port excalidraw`
3. **Check logs**: `docker logs excalidraw --tail 50`

### Drawings Not Saving

1. **Check browser storage**: Ensure local storage enabled
2. **Clear browser cache**: May resolve storage issues
3. **Export manually**: Save important work as files

### Collaboration Not Working

1. **Check network**: Ensure participants can access server
2. **Verify link**: Share correct collaboration URL
3. **Browser compatibility**: Use modern browsers

## 📊 Resource Usage

- **CPU**: Minimal (client-side rendering)
- **Memory**: ~50MB (very lightweight)
- **Storage**: None (browser storage only)

## 🎯 Use Cases

### Software Development

- System architecture diagrams
- Database schemas
- API flow diagrams
- Wireframes and mockups

### Project Management

- Flowcharts and processes
- Mind maps
- Gantt charts
- Organizational charts

### Education

- Concept diagrams
- Lesson planning
- Student collaboration
- Visual explanations

### General Use

- Brainstorming sessions
- Quick sketches
- Presentation diagrams
- Meeting notes

## 🎨 Drawing Tips

### Professional Diagrams

- **Use Grid**: Enable grid for alignment
- **Consistent Colors**: Stick to color palette
- **Arrow Labels**: Add context to connections
- **Group Elements**: Organize complex diagrams

### Collaboration Tips

- **Share Early**: Start collaboration session early
- **Use Comments**: Add text for context
- **Lock Elements**: Prevent accidental changes
- **Export Often**: Save progress regularly

## 📝 Notes

- **Hand-Drawn Style**: Unique aesthetic for diagrams
- **Browser-Based**: No installation needed
- **Keyboard Shortcuts**: Learn shortcuts for efficiency
- **Mobile Support**: Works on tablets and phones
- **Offline Capable**: PWA support for offline use

## 🔗 Resources

- [Official Website](https://excalidraw.com)
- [GitHub Repository](https://github.com/excalidraw/excalidraw)
- [Documentation](https://docs.excalidraw.com)
- [Libraries](https://libraries.excalidraw.com)

## ⌨️ Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Rectangle | R |
| Circle | O |
| Arrow | A |
| Line | L |
| Text | T |
| Pen | P |
| Undo | Ctrl+Z |
| Redo | Ctrl+Y |
| Delete | Delete |
| Duplicate | Ctrl+D |
| Group | Ctrl+G |
| Select All | Ctrl+A |

## 🌟 Best Practices

### For Teams

- Establish naming conventions
- Use consistent colors for element types
- Create shared libraries
- Regular exports for backup

### For Personal Use

- Organize drawings by project
- Export important diagrams
- Use layers for complex drawings
- Leverage keyboard shortcuts
