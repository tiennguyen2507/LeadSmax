# 🐳 Docker Setup Guide

## Quick Start

### Development Environment

```bash
# Build and run development environment
npm run docker:dev

# Access: http://localhost:3000 (no /admin prefix)
```

### Production Environment

```bash
# Build and run production environment
npm run docker:prod

# Access: http://localhost:3000/admin
```

### Staging Environment

```bash
# Build and run staging environment
npm run docker:staging

# Access: http://localhost:3001/admin
```

## Manual Docker Commands

### Build Images

```bash
# Development build
npm run docker:build-dev

# Production build
npm run docker:build-prod
```

### Run Containers

```bash
# Run development container
docker run -p 3000:3000 blog-admin:dev

# Run production container
docker run -p 3000:3000 blog-admin:prod
```

## Environment Variables

### Development

- `NEXT_PUBLIC_BASE_PATH=""` (no prefix)
- `NEXT_PUBLIC_API_URL="http://localhost:3001"`
- `NEXT_PUBLIC_APP_NAME="Blog Admin Dev"`
- `NEXT_PUBLIC_DEBUG_MODE="true"`

### Production

- `NEXT_PUBLIC_BASE_PATH="/admin"`
- `NEXT_PUBLIC_API_URL="https://api.yourdomain.com"`
- `NEXT_PUBLIC_APP_NAME="Blog Admin"`
- `NEXT_PUBLIC_DEBUG_MODE="false"`

### Staging

- `NEXT_PUBLIC_BASE_PATH="/admin"`
- `NEXT_PUBLIC_API_URL="https://api-staging.yourdomain.com"`
- `NEXT_PUBLIC_APP_NAME="Blog Admin Staging"`
- `NEXT_PUBLIC_DEBUG_MODE="true"`

## Docker Compose Profiles

### Development Profile

```bash
docker-compose --profile dev up --build
```

### Production Profile

```bash
docker-compose --profile prod up --build
```

### Staging Profile

```bash
docker-compose --profile staging up --build
```

## Custom Environment Variables

You can override environment variables by creating a `.env` file:

```bash
# .env
NEXT_PUBLIC_BASE_PATH=/custom
NEXT_PUBLIC_API_URL=https://custom-api.com
NEXT_PUBLIC_APP_NAME=Custom App
NEXT_PUBLIC_DEBUG_MODE=true
```

Then run:

```bash
docker-compose --env-file .env --profile dev up --build
```

## Multi-stage Build Benefits

1. **Smaller Image Size**: Only production dependencies
2. **Security**: Non-root user execution
3. **Optimization**: Standalone output for better performance
4. **Caching**: Efficient layer caching

## Troubleshooting

### Port Already in Use

```bash
# Stop existing containers
docker-compose down

# Or use different port
docker run -p 3001:3000 blog-admin:dev
```

### Build Cache Issues

```bash
# Clear build cache
docker builder prune

# Force rebuild
docker-compose build --no-cache
```

### Environment Variables Not Working

```bash
# Check build args
docker build --build-arg NEXT_PUBLIC_BASE_PATH="/admin" .

# Verify in container
docker run -it blog-admin:prod env | grep NEXT_PUBLIC
```
