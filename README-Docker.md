# LeadsMax - Docker Production Setup

Cấu hình Docker để chạy tất cả 3 project (Backend, Admin Frontend, Landing Page) cùng lúc trên production.

## 🚀 Cấu trúc Project

```
leadsmax/
├── blog-data-BE/          # Backend API (NestJS)
├── blog-admin-FE/         # Admin Frontend (Next.js)
├── lading-page-FE/        # Landing Page (Nuxt.js)
├── docker-compose.yml     # Docker Compose configuration
├── nginx.conf            # Nginx reverse proxy
├── docker-run.sh         # Management script
└── README-Docker.md      # This file
```

## 📋 Yêu cầu hệ thống

- Docker Engine 20.10+
- Docker Compose 2.0+
- ít nhất 4GB RAM
- 10GB disk space

## 🛠️ Cài đặt và chạy

### 1. Clone và cài đặt

```bash
# Đảm bảo bạn đang ở thư mục gốc của project
cd /path/to/leadsmax

# Cấp quyền thực thi cho script
chmod +x docker-run.sh
```

### 2. Chạy tất cả services

```bash
# Sử dụng script (khuyến nghị)
./docker-run.sh start

# Hoặc sử dụng docker-compose trực tiếp
docker-compose up -d --build
```

### 3. Kiểm tra trạng thái

```bash
./docker-run.sh status
```

## 🌐 Truy cập các services

Sau khi chạy thành công, các services sẽ có sẵn tại:

| Service         | URL                     | Mô tả               |
| --------------- | ----------------------- | ------------------- |
| Landing Page    | http://localhost        | Trang chủ chính     |
| Admin Panel     | http://localhost/admin  | Giao diện quản trị  |
| API Backend     | http://localhost/api    | REST API            |
| MongoDB Express | http://localhost:8081   | Quản lý database    |
| Health Check    | http://localhost/health | Kiểm tra trạng thái |

## 🔧 Quản lý Services

### Sử dụng script (khuyến nghị)

```bash
# Xem logs của tất cả services
./docker-run.sh logs

# Xem logs của service cụ thể
./docker-run.sh logs backend
./docker-run.sh logs frontend-admin
./docker-run.sh logs frontend-landing

# Restart tất cả services
./docker-run.sh restart

# Stop tất cả services
./docker-run.sh stop

# Xóa tất cả containers và volumes
./docker-run.sh cleanup

# Xem help
./docker-run.sh help
```

### Sử dụng docker-compose trực tiếp

```bash
# Xem logs
docker-compose logs -f

# Restart service cụ thể
docker-compose restart backend

# Rebuild và restart
docker-compose up -d --build

# Stop tất cả
docker-compose down

# Xóa volumes
docker-compose down -v
```

## 🔒 Bảo mật

### Environment Variables

Tạo file `.env` ở thư mục gốc để cấu hình:

```env
# MongoDB
MONGO_ROOT_USERNAME=leadsmax_user
MONGO_ROOT_PASSWORD=your_secure_password
MONGO_DATABASE=leadsmax_db

# Backend
NODE_ENV=production
JWT_SECRET=your_jwt_secret

# Frontend
NEXT_PUBLIC_API_URL=http://localhost/api
NUXT_PUBLIC_API_URL=http://localhost/api
```

### SSL/HTTPS

Để bật HTTPS:

1. Tạo thư mục `ssl/` và đặt certificates:

   ```bash
   mkdir ssl
   # Copy cert.pem và key.pem vào thư mục ssl/
   ```

2. Uncomment phần HTTPS trong `nginx.conf`

3. Restart services:
   ```bash
   ./docker-run.sh restart
   ```

## 📊 Monitoring

### Health Check

```bash
curl http://localhost/health
```

### Container Status

```bash
docker-compose ps
```

### Resource Usage

```bash
docker stats
```

## 🐛 Troubleshooting

### Logs

```bash
# Xem logs của tất cả services
./docker-run.sh logs

# Xem logs của service cụ thể
./docker-run.sh logs backend
```

### Common Issues

1. **Port conflicts**: Đảm bảo ports 80, 3000, 3001, 3002, 8081 không bị sử dụng
2. **Memory issues**: Tăng RAM cho Docker (ít nhất 4GB)
3. **Build failures**: Kiểm tra logs build trong từng service

### Reset Everything

```bash
# Dừng và xóa tất cả
./docker-run.sh cleanup

# Chạy lại
./docker-run.sh start
```

## 🔄 Development vs Production

### Development

```bash
# Chạy từng service riêng lẻ
cd blog-data-BE && npm run start:dev
cd blog-admin-FE && npm run dev
cd lading-page-FE && yarn dev
```

### Production

```bash
# Chạy tất cả với Docker
./docker-run.sh start
```

## 📝 Notes

- MongoDB data được lưu trong Docker volume `mongo_data`
- Nginx làm reverse proxy và load balancer
- Tất cả services được kết nối qua Docker network `leadsmax_network`
- Rate limiting được áp dụng cho API và general traffic
- Gzip compression được bật cho tất cả responses

## 🤝 Support

Nếu gặp vấn đề, hãy kiểm tra:

1. Docker logs: `./docker-run.sh logs`
2. Container status: `./docker-run.sh status`
3. Resource usage: `docker stats`
