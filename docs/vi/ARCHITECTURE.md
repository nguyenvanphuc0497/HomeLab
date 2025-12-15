# 🏗️ Thiết Kế Kiến Trúc

Tài liệu này mô tả triết lý thiết kế của kho lưu trữ HomeLab. Chúng tôi áp dụng thiết kế **Cơ sở hạ tầng định hướng dịch vụ (Service-Oriented Infrastructure)** để đảm bảo khả năng mở rộng, bảo trì và tái sử dụng.

## Khái niệm cốt lõi

### 1. Tách biệt mối quan tâm (Services vs. Servers)

Chúng tôi phân biệt rõ ràng giữa **Định nghĩa** (Cái gì) và **Triển khai** (Ở đâu).

- **`services/` (Cái gì - Service)**:
  - Chứa **định nghĩa dịch vụ thuần túy** (file Docker Compose).
  - Độc lập với phần cứng vật lý.
  - Định nghĩa: Container image, cổng (internal), volumes, dependencies.
  - *Ví dụ:* `services/gitea` định nghĩa cách Gitea chạy chung.

- **`servers/` (Ở đâu - Deployment)**:
  - Chứa **cấu hình triển khai** cho các node cụ thể (ví dụ: `raspi4`, `intel-nuc`).
  - Sử dụng Docker Compose `include` để nhập (import) các services.
  - Định nghĩa: Biến môi trường, các ghi đè (overrides) cụ thể cho node đó.
  - *Ví dụ:* `servers/raspi4` import `services/gitea` và thiết lập mật khẩu.

### 2. Lợi ích của thiết kế này

#### ✅ Tái sử dụng (DRY - Don't Repeat Yourself)
Nếu bạn muốn di chuyển một dịch vụ (ví dụ: Gitea) từ Raspberry Pi 4 sang Pi 5:
- **Cách cũ:** Copy/paste hàng trăm dòng YAML. Dễ sai sót.
- **Cách mới:** Chỉ cần sửa một dòng trong phần `include`.

#### 🧘 Gọn gàng và Sạch sẽ
Cấu hình của Node rất rõ ràng. Một server chạy 10 dịch vụ chỉ có file `docker-compose.yml` dài 20 dòng thay vì một file "mì ống" dài 500 dòng.

#### 🧩 Tính mô-đun (Modularity)
Mỗi service là một module. Bạn có thể nâng cấp, test và sửa lỗi "Gitea module" mà không sợ ảnh hưởng đến "Home Assistant module".

## Ví dụ cấu trúc thư mục

```text
.
├── services/               # 🧩 Các Module Dịch vụ Tái sử dụng
│   └── gitea/
│       └── docker-compose.yml  # Định nghĩa gốc
│
└── servers/                # 📍 Cấu hình Triển khai từng Node
    └── raspi4/
        ├── docker-compose.yml  # Includes ../../services/gitea
        └── .env                # Secrets riêng cho node này
```

## Cách thêm mới một dịch vụ

1.  **Định nghĩa**: Tạo `services/<tên>/docker-compose.yml`.
2.  **Triển khai**: Thêm nó vào `servers/<node>/docker-compose.yml` trong phần `include`.
