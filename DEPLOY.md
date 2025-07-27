# Hướng dẫn Deploy LeadsMax với Docker Compose

## Cấu trúc Project

```
leadsmax/
├── blog-admin-FE/          # Next.js Admin Frontend
├── blog-data-BE/           # NestJS Backend API
├── lading-page-FE/         # Nuxt.js Landing Page
├── docker-compose.yml      # Docker Compose configuration
├── nginx.conf             # Nginx reverse proxy
├── docker.env             # Environment variables
└── DEPLOY.md              # This file
```

## Yêu cầu hệ thống

- Docker Engine 20.10+
- Docker Compose 2.0+
- ít nhất 4GB RAM
- 20GB disk space

## Các bước deploy

### 1. Chuẩn bị VPS

```bash
# Cập nhật hệ thống
sudo apt update && sudo apt upgrade -y

# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Cài đặt Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Thêm user vào docker group
sudo usermod -aG docker $USER
```

### 2. Clone project

```bash
git clone <your-repository-url>
cd leadsmax
```

### 3. Cấu hình domain

Chỉnh sửa file `nginx.conf` và thay thế `yourdomain.com` bằng domain thực tế của bạn:

```nginx
server_name api.yourdomain.com;     # -> api.leadsmax.com
server_name admin.yourdomain.com;   # -> admin.leadsmax.com
server_name yourdomain.com;         # -> leadsmax.com
```

### 4. Cấu hình SSL (Tùy chọn)

Tạo thư mục SSL và thêm certificate:

```bash
mkdir ssl
# Copy SSL certificate vào thư mục ssl/
```

### 5. Chạy hệ thống

```bash
# Build và start tất cả services
docker-compose up -d --build

# Kiểm tra status
docker-compose ps

# Xem logs
docker-compose logs -f
```

### 6. Kiểm tra các services

- **Backend API**: http://your-vps-ip:3000
- **Admin Frontend**: http://your-vps-ip:3001
- **Landing Page**: http://your-vps-ip:3002
- **MongoDB Express**: http://your-vps-ip:8081

## Các lệnh hữu ích

### Quản lý services

```bash
# Start tất cả services
docker-compose up -d

# Stop tất cả services
docker-compose down

# Restart service cụ thể
docker-compose restart backend

# Xem logs của service
docker-compose logs -f backend

# Rebuild và restart
docker-compose up -d --build
```

### Backup database

```bash
# Backup MongoDB
docker exec mongo_leadsmax mongodump --out /data/backup

# Copy backup từ container
docker cp mongo_leadsmax:/data/backup ./backup
```

### Update code

```bash
# Pull code mới
git pull

# Rebuild và restart
docker-compose up -d --build
```

## Cấu hình Production

### 1. Firewall

```bash
# Mở các port cần thiết
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

### 2. Domain và DNS

- Trỏ domain chính về IP của VPS
- Tạo subdomain cho API và Admin panel
- Cấu hình SSL certificate (Let's Encrypt)

### 3. Monitoring

```bash
# Cài đặt monitoring tools
docker run -d \
  --name=portainer \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  portainer/portainer-ce
```

## Troubleshooting

### Kiểm tra logs

```bash
# Xem logs của tất cả services
docker-compose logs

# Xem logs của service cụ thể
docker-compose logs backend
docker-compose logs admin-frontend
docker-compose logs landing-frontend
```

### Kiểm tra network

```bash
# Kiểm tra network connectivity
docker network ls
docker network inspect leadsmax_leadsmax-network
```

### Restart service

```bash
# Restart service có vấn đề
docker-compose restart <service-name>
```

## Performance Optimization

### 1. Resource limits

Thêm vào `docker-compose.yml`:

```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: "0.5"
```

### 2. Caching

- Sử dụng Redis cho session storage
- Cấu hình Nginx caching
- CDN cho static assets

### 3. Database optimization

- Index MongoDB collections
- Connection pooling
- Regular backups

## Security

### 1. Environment variables

- Không commit file `.env` vào git
- Sử dụng Docker secrets cho sensitive data
- Rotate passwords regularly

### 2. Network security

- Sử dụng internal Docker networks
- Restrict external access
- Implement rate limiting

### 3. Application security

- Keep dependencies updated
- Implement proper authentication
- Use HTTPS everywhere
