#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker first."
        exit 1
    fi
}

# Function to build and start all services
start_all() {
    print_status "Building and starting all services..."
    docker-compose up -d --build
    if [ $? -eq 0 ]; then
        print_success "All services started successfully!"
        print_status "Services are available at:"
        echo "  - Landing Page: http://localhost"
        echo "  - Admin Panel: http://localhost/admin"
        echo "  - API: http://localhost/api"
        echo "  - MongoDB Express: http://localhost:8081"
        echo "  - Health Check: http://localhost/health"
    else
        print_error "Failed to start services"
        exit 1
    fi
}

# Function to stop all services
stop_all() {
    print_status "Stopping all services..."
    docker-compose down
    print_success "All services stopped"
}

# Function to restart all services
restart_all() {
    print_status "Restarting all services..."
    docker-compose down
    docker-compose up -d --build
    print_success "All services restarted"
}

# Function to show logs
show_logs() {
    if [ -z "$1" ]; then
        print_status "Showing logs for all services..."
        docker-compose logs -f
    else
        print_status "Showing logs for service: $1"
        docker-compose logs -f "$1"
    fi
}

# Function to show status
show_status() {
    print_status "Container status:"
    docker-compose ps
}

# Function to clean up
cleanup() {
    print_warning "This will remove all containers, networks, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_status "Cleaning up..."
        docker-compose down -v --rmi all
        print_success "Cleanup completed"
    else
        print_status "Cleanup cancelled"
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Build and start all services"
    echo "  stop      Stop all services"
    echo "  restart   Restart all services"
    echo "  logs      Show logs (all services or specific service)"
    echo "  status    Show container status"
    echo "  cleanup   Remove all containers, networks, and volumes"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs backend"
    echo "  $0 status"
}

# Main script logic
case "$1" in
    "start")
        check_docker
        start_all
        ;;
    "stop")
        check_docker
        stop_all
        ;;
    "restart")
        check_docker
        restart_all
        ;;
    "logs")
        check_docker
        show_logs "$2"
        ;;
    "status")
        check_docker
        show_status
        ;;
    "cleanup")
        check_docker
        cleanup
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        show_help
        exit 1
        ;;
esac 