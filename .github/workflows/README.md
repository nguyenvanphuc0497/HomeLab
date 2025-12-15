# 🔄 CI/CD Workflows

This directory contains GitHub Actions workflows for automated testing, validation, and deployment.

## 📋 Available Workflows

### `ci.yml` - Continuous Integration & Deployment

Automated pipeline that runs on every push and pull request.

#### Jobs Overview

1. **bootstrap** - Initial repository check
2. **markdown-lint** - Lint all Markdown files
3. **yaml-lint** - Lint all YAML files
4. **compose-validate** - Validate Docker Compose syntax
5. **compose-dry-run** - Preview deployments (all servers)
6. **compose-test-deploy** - Test deploy with platform emulation (main branch only)
7. **deploy** - Actual deployment to servers (main branch, self-hosted runner)

#### Workflow Triggers

- **On Push to `main`**: All jobs run, including test deploy and actual deployment
- **On Pull Request**: Validation and dry-run only (no actual deployment)
- **On Push to other branches**: Validation and dry-run only

## 🧪 Testing Jobs

### compose-validate
- Validates syntax of all Docker Compose files
- Works without `.env` files (syntax-only check)
- Runs on every push/PR

### compose-dry-run
- Preview what would be deployed for each server
- Shows services and images that would be pulled
- Matrix strategy tests all 5 servers in parallel
- No actual deployment, safe for PRs

### compose-test-deploy
- **Only runs on `main` branch pushes**
- Tests actual deployment with platform emulation
- Currently tests: raspi5, raspi4, intel-nuc
- Uses QEMU for cross-platform emulation
- Validates that images can be pulled and configs are valid

## 🚀 Deployment Job

### deploy
- **Only runs on `main` branch pushes**
- Requires **self-hosted runner** configured
- Currently deploys to: raspi5 (configurable via matrix)
- Uses Makefile commands for consistent deployment

### Setup Self-Hosted Runner

1. **Install runner on your server** (e.g., Raspberry Pi 4):
   ```bash
   mkdir actions-runner && cd actions-runner
   curl -o actions-runner-linux-arm64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-arm64-2.311.0.tar.gz
   tar xzf ./actions-runner-linux-arm64-2.311.0.tar.gz
   ```

2. **Configure runner**:
   ```bash
   ./config.sh --url https://github.com/YOUR_USERNAME/homelab --token YOUR_TOKEN
   ```

3. **Run as service**:
   ```bash
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```

4. **Label runner** (optional):
   - Edit `.github/workflows/ci.yml` to use specific labels:
     ```yaml
     runs-on: [self-hosted, raspi4]
     ```

## 🔒 Security Considerations

### Secrets Management

The `deploy` job may need access to:
- SSH keys (if deploying via SSH)
- Server credentials (if needed)
- `.env` files (should be on server, not in Git)

**Never commit secrets!** Use GitHub Actions secrets:
- Go to repository Settings → Secrets and variables → Actions
- Add secrets like `SSH_PRIVATE_KEY`, `SERVER_HOST`, etc.

### Environment Variables

For test deployments, you may need to:
1. Create `.env` files on the self-hosted runner
2. Store them securely (not in Git)
3. Reference them in workflow if needed

## 📊 Viewing Reports & Results

### 1. GitHub Actions UI (Primary Method)

**Access:** `https://github.com/YOUR_USERNAME/homelab/actions`

**Features:**
- ✅ **Summary Report** - Automatically generated at the end of each run
- ✅ **Job Status** - See which jobs passed/failed
- ✅ **Logs** - Click any job to see detailed logs
- ✅ **Artifacts** - Download validation reports and logs

**How to view:**
1. Go to your repository → **Actions** tab
2. Click on the latest workflow run
3. Scroll down to see **Summary** section (auto-generated)
4. Click on any job to see detailed logs
5. Scroll to bottom to download **Artifacts**

### 2. Summary Report (Auto-generated)

After each CI run, a summary report is automatically created showing:
- ✅ Validation results (Markdown, YAML, Compose)
- ✅ Dry run status
- ✅ Artifacts available for download
- ✅ Next steps/action items

**Location:** Visible at the bottom of workflow run page

### 3. Artifacts (Downloadable Reports)

**Available Artifacts:**
- `validation-report` - Detailed compose validation results
- `dry-run-<server>` - Dry run results for each server
- `deploy-<server>-logs` - Deployment logs (main branch only)

**How to download:**
1. Go to workflow run page
2. Scroll to **Artifacts** section (bottom of page)
3. Click artifact name to download
4. Extract ZIP file to view reports

**Retention:**
- Validation reports: 7 days
- Deployment logs: 30 days

### 4. PR Comments (Pull Requests Only)

When you open a Pull Request, CI automatically comments with:
- ✅ Status of all validation checks
- ✅ Link to full workflow run
- ✅ Action items if errors found

**Location:** PR conversation tab

### 5. Email Notifications (Optional)

GitHub can send email notifications when:
- Workflow fails
- Workflow succeeds (if configured)
- PR status changes

**Setup:** Repository Settings → Notifications

## 📊 Workflow Status

View workflow runs at:
`https://github.com/YOUR_USERNAME/homelab/actions`

## 🛠️ Customization

### Add More Servers to Test Deploy

Edit `compose-test-deploy` job matrix:
```yaml
matrix:
  server:
    - name: raspi5
      platform: linux/arm64
    - name: raspi3
      platform: linux/arm/v7  # Add this
```

### Change Deployment Target

Edit `deploy` job matrix:
```yaml
matrix:
  server: [raspi5, raspi4]  # Add more servers
```

### Skip Deployment

To temporarily disable deployment:
1. Comment out the `deploy` job
2. Or add condition: `if: false`

## 🐛 Troubleshooting

### Test Deploy Fails

- Check if images are available for target platform
- Verify platform emulation is working (QEMU installed)
- Check Docker Compose syntax

### Deployment Fails

- Verify self-hosted runner is online
- Check runner has access to server directories
- Ensure `.env` files exist on server
- Check SSH keys/permissions if using SSH

### Dry Run Shows Errors

- Usually means compose file syntax issue
- Check `compose-validate` job output
- Verify all required variables are defined

## 📝 Example Workflow Run

```
✅ bootstrap
✅ markdown-lint
✅ yaml-lint
✅ compose-validate
✅ compose-dry-run (raspi3, raspi4, raspi5, intel-nuc, amd-ovm)
✅ compose-test-deploy (raspi5, raspi4, intel-nuc)  # main branch only
✅ deploy (raspi5)  # main branch only, self-hosted runner
```

---

**See also:** [`../README.md`](../../README.md) for project overview.

