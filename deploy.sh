#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting LeadsMax Deployment...${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  .env file not found. Creating from docker.env...${NC}"
    cp docker.env .env
    echo -e "${YELLOW}⚠️  Please edit .env file with your actual configuration${NC}"
fi

# Stop existing containers
echo -e "${YELLOW}🛑 Stopping existing containers...${NC}"
docker-compose down

# Remove old images (optional)
read -p "Do you want to remove old images? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}🗑️  Removing old images...${NC}"
    docker-compose down --rmi all
fi

# Build and start services
echo -e "${GREEN}🔨 Building and starting services...${NC}"
docker-compose up -d --build

# Wait for services to be ready
echo -e "${YELLOW}⏳ Waiting for services to be ready...${NC}"
sleep 30

# Check service status
echo -e "${GREEN}📊 Checking service status...${NC}"
docker-compose ps

# Show logs
echo -e "${GREEN}📋 Recent logs:${NC}"
docker-compose logs --tail=20

echo -e "${GREEN}✅ Deployment completed!${NC}"
echo -e "${GREEN}🌐 Services available at:${NC}"
echo -e "   Backend API: ${YELLOW}http://localhost:3000${NC}"
echo -e "   Admin Frontend: ${YELLOW}http://localhost:3001${NC}"
echo -e "   Landing Page: ${YELLOW}http://localhost:3002${NC}"
echo -e "   MongoDB Express: ${YELLOW}http://localhost:8081${NC}"

echo -e "${GREEN}📝 Useful commands:${NC}"
echo -e "   View logs: ${YELLOW}docker-compose logs -f${NC}"
echo -e "   Stop services: ${YELLOW}docker-compose down${NC}"
echo -e "   Restart services: ${YELLOW}docker-compose restart${NC}" 