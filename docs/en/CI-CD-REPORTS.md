# 📊 CI/CD Reports Guide

A comprehensive guide on how to view and understand CI/CD reports, artifacts, and workflow results in the HomeLab project.

## 🎯 Viewing Reports

### 1. GitHub Actions UI (Recommended)

**URL:** `https://github.com/YOUR_USERNAME/homelab/actions`

**Steps:**

1. Navigate to the **Actions** tab in your repository
2. **Select the workflow run** you want to view (latest runs appear at the top)
3. **View Summary Report** (automatically generated at the bottom of the page)
4. **Click on any job** to see detailed logs
5. **Download Artifacts** at the bottom of the page

**What you'll see:**

```
┌─────────────────────────────────────┐
│  ✅ All jobs completed              │
│  📊 Summary Report                  │
│  ─────────────────────────────────  │
│  ✅ Markdown Lint                   │
│  ✅ YAML Lint                       │
│  ✅ Compose Validate                │
│  ✅ Dry Run                         │
│                                     │
│  📦 Artifacts                       │
│  • validation-report                │
│  • dry-run-raspi5                   │
└─────────────────────────────────────┘
```

### 2. Summary Report (Auto-generated)

**Location:** Bottom of each workflow run page

**Contents:**
- Summary table of validation results
- Links to artifacts
- Next steps guidance

**Example:**
```markdown
# 📊 CI/CD Summary Report

## ✅ Validation Results

| Job | Status |
|-----|--------|
| Markdown Lint | ✅ Passed |
| YAML Lint | ✅ Passed |
| Compose Validate | ✅ Passed |
| Dry Run | ✅ Passed |

## 📦 Artifacts
Check the Artifacts section below to download detailed reports.
```

### 3. Artifacts (Downloadable)

**Available Artifacts:**

| Artifact Name | Content | Retention |
|--------------|---------|-----------|
| `validation-report` | Compose file validation results | 7 days |
| `dry-run-<server>` | Dry run results for each server | 7 days |
| `deploy-<server>-logs` | Deployment logs (main branch only) | 30 days |

**How to download:**
1. Go to workflow run page
2. Scroll to **Artifacts** section (bottom of page)
3. Click artifact name to download ZIP
4. Extract to view contents

### 4. PR Comments (Automatic)

When you open a Pull Request, CI automatically comments:

```markdown
## 🔍 CI/CD Validation Results

| Check | Status |
|-------|--------|
| Markdown Lint | ✅ Passed |
| YAML Lint | ✅ Passed |
| Compose Validate | ✅ Passed |
| Dry Run | ✅ Passed |

✅ **All checks passed!**
```

**Location:** PR **Conversation** tab

### 5. Job Logs (Detailed)

**How to view:**
1. Click on the job you want to see (e.g., "Validate Docker Compose")
2. View real-time logs or scroll to see full output
3. Search within logs (Ctrl+F / Cmd+F)

**Color coding:**
- 🟢 Green = Success
- 🔴 Red = Failed
- 🟡 Yellow = Warning
- ⚪ Gray = Skipped

## 📈 Understanding Results

### Status Icons

- ✅ **Success** - Job completed successfully
- ❌ **Failure** - Job failed, needs fixing
- ⚠️ **Warning** - Warning present but didn't fail
- ⏭️ **Skipped** - Job was skipped (due to conditions)

### Common Issues & Solutions

#### ❌ Compose Validate Failed

**Causes:**
- Syntax error in docker-compose.yml
- Missing required fields
- Invalid YAML format

**How to fix:**
1. Check logs of "Validate Docker Compose" job
2. Find error line (usually includes line number)
3. Fix syntax error
4. Test locally: `make validate-compose`

#### ❌ Dry Run Failed

**Causes:**
- Compose file has errors
- Missing environment variables (expected if no .env)

**How to fix:**
- If missing .env: Normal, no fix needed
- If other errors: Check logs for details

#### ⚠️ Test Deploy Warning

**Causes:**
- Image not available for target platform
- Platform emulation issue

**How to fix:**
- Check if image supports the platform
- Try pulling image manually: `docker pull <image> --platform <platform>`

## 🔔 Notifications

### Email Notifications

GitHub can send emails when:
- Workflow fails
- Workflow succeeds (if enabled)
- PR status changes

**Setup:**
1. GitHub Settings → Notifications
2. Enable "Actions"
3. Select events you want to receive

### Badge Status

Add badge to README to display status:

```markdown
![CI](https://github.com/YOUR_USERNAME/homelab/workflows/CI/badge.svg)
```

## 📱 Mobile App

GitHub Mobile App allows:
- View workflow runs
- View job status
- Receive notifications

**Download:** iOS App Store / Google Play Store

## 🎯 Best Practices

1. **Check Summary First** - Review overview before diving into details
2. **Download Artifacts** - Save important reports
3. **Fix Errors Immediately** - Don't let errors accumulate
4. **Review PR Comments** - Read comments before merging
5. **Monitor Regularly** - Check Actions tab frequently

## 🆘 Troubleshooting

### Can't see Summary Report?

- Ensure workflow has completed
- Refresh the page
- Check for errors in workflow

### Can't download Artifacts?

- Check retention period (may have expired)
- Try again after a few minutes
- Check GitHub storage limit

### PR doesn't have comment?

- Ensure workflow runs on PR (not direct push)
- Check for errors in "Comment on PR" job
- May need permissions to comment

---

**See also:**
- [`.github/workflows/README.md`](../../.github/workflows/README.md)
- [Vietnamese Documentation](../vi/CI-CD-REPORTS.md)
- [Documentation Index](../README.md)

