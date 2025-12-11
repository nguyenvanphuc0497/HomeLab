# 🔧 Scripts Directory

Utility scripts for development, validation, and maintenance.

## 📋 Available Scripts

### `validate-compose.sh`

Validates all Docker Compose files in the repository. Can run on **any platform** (MacBook, Linux) to check syntax before committing.

### `test-deploy.sh`

Helper script to test deployments on MacBook with platform emulation. Useful for testing ARM64 compose files on Intel/Apple Silicon Macs.

**Usage:**
```bash
# Preview deployment
./scripts/test-deploy.sh raspi5 dry-run

# Test deploy (with platform emulation)
./scripts/test-deploy.sh raspi5 test-deploy

# Stop test containers
./scripts/test-deploy.sh raspi5 test-down
```

**What it does:**
- Navigates to server directory
- Runs appropriate Makefile commands
- Handles platform emulation automatically
- Provides confirmation prompts for actual deployments

**Usage:**
```bash
# From repo root
bash scripts/validate-compose.sh

# Or use Makefile
make validate-compose
```

**What it does:**
- Checks syntax of all `docker-compose.yml` files in `servers/` and `services/`
- Validates YAML structure and Docker Compose format
- Doesn't require `.env` files (warns if missing, but that's expected)
- Works cross-platform (validates syntax even if platform doesn't match)

**Example output:**
```
🔍 Validating Docker Compose files...

📄 Checking: servers/raspi5/docker-compose.yml
   ✅ Valid

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ All compose files validated successfully! (5 files)
```

## 🚀 Development Workflow

### On MacBook (Development)

1. **Edit compose files** in your editor
2. **Validate syntax** before committing:
   ```bash
   make validate-compose
   ```
3. **Run linters**:
   ```bash
   make lint
   ```
4. **Full validation**:
   ```bash
   make test  # Runs validate + lint
   ```
5. **Commit** when all checks pass

### On Server (Deployment)

1. **Pull latest code**:
   ```bash
   git pull
   ```
2. **Validate** (optional, but recommended):
   ```bash
   cd servers/raspi5
   make check
   ```
3. **Deploy**:
   ```bash
   make deploy
   ```

## 📝 Adding New Scripts

When adding new scripts:

1. Make them executable: `chmod +x scripts/your-script.sh`
2. Add shebang: `#!/bin/bash`
3. Document usage in this README
4. Add to `.gitignore` if they generate temporary files

## 🔒 Security Notes

- Scripts should **never** contain secrets
- Use environment variables or `.env` files (gitignored)
- Validate user input if scripts accept arguments
- Prefer `bash -e` (exit on error) for safety

---

**See also:** [`../README.md`](../README.md) for project overview.

