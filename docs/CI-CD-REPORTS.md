# 📊 CI/CD Reports Guide

Hướng dẫn chi tiết về cách xem và hiểu các báo cáo CI/CD.

## 🎯 Các Cách Xem Report

### 1. GitHub Actions UI (Khuyến nghị)

**Đường dẫn:** `https://github.com/YOUR_USERNAME/homelab/actions`

**Các bước:**

1. **Vào tab Actions** trong repository
2. **Chọn workflow run** bạn muốn xem (run mới nhất ở trên cùng)
3. **Xem Summary Report** (tự động tạo ở cuối trang)
4. **Click vào từng job** để xem logs chi tiết
5. **Download Artifacts** ở cuối trang

**Màn hình bạn sẽ thấy:**

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

### 2. Summary Report (Tự động)

**Vị trí:** Cuối mỗi workflow run

**Nội dung:**
- Bảng tổng hợp kết quả validation
- Link đến artifacts
- Hướng dẫn next steps

**Ví dụ:**
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

### 3. Artifacts (Tải về)

**Các artifacts có sẵn:**

| Artifact Name | Nội dung | Retention |
|--------------|---------|-----------|
| `validation-report` | Kết quả validate compose files | 7 ngày |
| `dry-run-<server>` | Kết quả dry run cho từng server | 7 ngày |
| `deploy-<server>-logs` | Logs deployment (main branch) | 30 ngày |

**Cách tải:**
1. Vào workflow run page
2. Scroll xuống phần **Artifacts**
3. Click tên artifact để tải ZIP
4. Giải nén để xem nội dung

### 4. PR Comments (Tự động)

Khi mở Pull Request, CI sẽ tự động comment:

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

**Vị trí:** Tab **Conversation** của PR

### 5. Job Logs (Chi tiết)

**Cách xem:**
1. Click vào job bạn muốn xem (ví dụ: "Validate Docker Compose")
2. Xem logs real-time hoặc scroll để xem toàn bộ
3. Có thể search trong logs (Ctrl+F / Cmd+F)

**Màu sắc:**
- 🟢 Xanh lá = Success
- 🔴 Đỏ = Failed
- 🟡 Vàng = Warning
- ⚪ Xám = Skipped

## 📈 Hiểu Kết Quả

### Status Icons

- ✅ **Success** - Job chạy thành công
- ❌ **Failure** - Job bị lỗi, cần fix
- ⚠️ **Warning** - Có cảnh báo nhưng không fail
- ⏭️ **Skipped** - Job bị skip (do điều kiện)

### Common Issues & Solutions

#### ❌ Compose Validate Failed

**Nguyên nhân:**
- Syntax error trong docker-compose.yml
- Thiếu required fields
- Invalid YAML format

**Cách fix:**
1. Xem logs của job "Validate Docker Compose"
2. Tìm dòng lỗi (thường có line number)
3. Fix syntax error
4. Test local: `make validate-compose`

#### ❌ Dry Run Failed

**Nguyên nhân:**
- Compose file có lỗi
- Missing environment variables (expected nếu không có .env)

**Cách fix:**
- Nếu thiếu .env: Bình thường, không cần fix
- Nếu có lỗi khác: Xem logs để biết chi tiết

#### ⚠️ Test Deploy Warning

**Nguyên nhân:**
- Image không available cho platform đó
- Platform emulation issue

**Cách fix:**
- Kiểm tra image có hỗ trợ platform không
- Thử pull image manually: `docker pull <image> --platform <platform>`

## 🔔 Notifications

### Email Notifications

GitHub có thể gửi email khi:
- Workflow fails
- Workflow succeeds (nếu bật)
- PR status changes

**Setup:**
1. GitHub Settings → Notifications
2. Bật "Actions"
3. Chọn events bạn muốn nhận

### Badge Status

Thêm badge vào README để hiển thị status:

```markdown
![CI](https://github.com/YOUR_USERNAME/homelab/workflows/CI/badge.svg)
```

## 📱 Mobile App

GitHub Mobile App cho phép:
- Xem workflow runs
- Xem job status
- Nhận notifications

**Download:** iOS App Store / Google Play Store

## 🎯 Best Practices

1. **Check Summary First** - Xem tổng quan trước khi vào chi tiết
2. **Download Artifacts** - Lưu reports quan trọng
3. **Fix Errors Immediately** - Đừng để lỗi tích tụ
4. **Review PR Comments** - Đọc comment trước khi merge
5. **Monitor Regularly** - Check Actions tab thường xuyên

## 🆘 Troubleshooting

### Không thấy Summary Report?

- Đảm bảo workflow đã chạy xong
- Refresh trang
- Check xem có lỗi trong workflow không

### Artifacts không tải được?

- Check retention period (có thể đã hết hạn)
- Thử lại sau vài phút
- Check GitHub storage limit

### PR không có comment?

- Đảm bảo workflow chạy trên PR (không phải push trực tiếp)
- Check xem có lỗi trong job "Comment on PR" không
- Có thể cần permissions để comment

---

**Xem thêm:** [`.github/workflows/README.md`](../.github/workflows/README.md)

