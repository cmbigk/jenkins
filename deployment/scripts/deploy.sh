#!/bin/bash

# Deployment script with Blue-Green deployment strategy
# Usage: ./deploy.sh <service-name> <version>

SERVICE=$1
VERSION=$2
ENVIRONMENT=${3:-dev}

if [ -z "$SERVICE" ] || [ -z "$VERSION" ]; then
    echo "Usage: ./deploy.sh <service-name> <version> [environment]"
    exit 1
fi

echo "========================================"
echo "Deploying $SERVICE version $VERSION"
echo "Environment: $ENVIRONMENT"
echo "========================================"

# Deploy new version (green)
docker run -d \
    --name ${SERVICE}-green \
    --network buy-01_default \
    -e SPRING_PROFILES_ACTIVE=$ENVIRONMENT \
    ecommerce/${SERVICE}:${VERSION}

# Health check on new version
echo "Waiting for new version to be ready..."
sleep 15

if curl -f http://localhost:8081/actuator/health; then
    echo "✅ New version is healthy"
    
    # Switch traffic (stop old, rename new)
    echo "Switching traffic to new version..."
    docker stop $SERVICE 2>/dev/null || true
    docker rm $SERVICE 2>/dev/null || true
    docker rename ${SERVICE}-green $SERVICE
    
    echo "✅ Deployment successful!"
else
    echo "❌ New version health check failed - rolling back..."
    docker stop ${SERVICE}-green
    docker rm ${SERVICE}-green
    exit 1
fi
