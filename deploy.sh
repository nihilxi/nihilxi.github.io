#!/bin/bash

# DevOps Portfolio Deployment Script
# Author: Hubert Zych
# Description: Automated deployment script for the portfolio website

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOCKER_IMAGE="portfolio"
DOCKER_TAG="latest"
CONTAINER_NAME="portfolio-app"
PORT="8080"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    log_success "Docker is available"
}

cleanup_existing() {
    log_info "Cleaning up existing containers..."
    if sudo docker ps -q -f name=$CONTAINER_NAME | grep -q .; then
        log_info "Stopping existing container..."
        sudo docker stop $CONTAINER_NAME
    fi
    
    if sudo docker ps -aq -f name=$CONTAINER_NAME | grep -q .; then
        log_info "Removing existing container..."
        sudo docker rm $CONTAINER_NAME
    fi
    
    log_success "Cleanup completed"
}

build_image() {
    log_info "Building Docker image..."
    sudo docker build -t $DOCKER_IMAGE:$DOCKER_TAG .
    
    if [ $? -eq 0 ]; then
        log_success "Docker image built successfully"
    else
        log_error "Failed to build Docker image"
        exit 1
    fi
}

run_tests() {
    log_info "Running container tests..."
    
    # Start test container
    sudo docker run -d --name ${CONTAINER_NAME}-test -p 9999:80 $DOCKER_IMAGE:$DOCKER_TAG
    
    # Wait for container to start
    sleep 5
    
    # Test health endpoint
    if curl -f http://localhost:9999/health > /dev/null 2>&1; then
        log_success "Health check passed"
    else
        log_error "Health check failed"
        sudo docker stop ${CONTAINER_NAME}-test
        sudo docker rm ${CONTAINER_NAME}-test
        exit 1
    fi
    
    # Test main page
    if curl -f http://localhost:9999/ > /dev/null 2>&1; then
        log_success "Main page test passed"
    else
        log_error "Main page test failed"
        sudo docker stop ${CONTAINER_NAME}-test
        sudo docker rm ${CONTAINER_NAME}-test
        exit 1
    fi
    
    # Cleanup test container
    sudo docker stop ${CONTAINER_NAME}-test
    sudo docker rm ${CONTAINER_NAME}-test
    
    log_success "All tests passed"
}

deploy_container() {
    log_info "Deploying container..."
    
    sudo docker run -d \
        --name $CONTAINER_NAME \
        -p $PORT:80 \
        --restart unless-stopped \
        $DOCKER_IMAGE:$DOCKER_TAG
    
    if [ $? -eq 0 ]; then
        log_success "Container deployed successfully"
        log_info "Website available at: http://localhost:$PORT"
    else
        log_error "Failed to deploy container"
        exit 1
    fi
}

show_status() {
    log_info "Container status:"
    sudo docker ps -f name=$CONTAINER_NAME
    
    log_info "Container logs:"
    sudo docker logs $CONTAINER_NAME --tail 10
}

# Main execution
main() {
    log_info "Starting DevOps Portfolio deployment..."
    
    check_docker
    cleanup_existing
    build_image
    run_tests
    deploy_container
    show_status
    
    log_success "Deployment completed successfully!"
    log_info "Access your portfolio at: http://localhost:$PORT"
}

# Help function
show_help() {
    echo "DevOps Portfolio Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -c, --cleanup  Only cleanup existing containers"
    echo "  -b, --build    Only build the Docker image"
    echo "  -t, --test     Only run tests"
    echo "  -d, --deploy   Only deploy (assumes image exists)"
    echo "  -s, --status   Show container status"
    echo ""
    echo "Examples:"
    echo "  $0                # Full deployment"
    echo "  $0 --build        # Only build image"
    echo "  $0 --cleanup      # Only cleanup"
    echo ""
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -c|--cleanup)
        check_docker
        cleanup_existing
        exit 0
        ;;
    -b|--build)
        check_docker
        build_image
        exit 0
        ;;
    -t|--test)
        check_docker
        run_tests
        exit 0
        ;;
    -d|--deploy)
        check_docker
        cleanup_existing
        deploy_container
        show_status
        exit 0
        ;;
    -s|--status)
        check_docker
        show_status
        exit 0
        ;;
    "")
        main
        ;;
    *)
        log_error "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
