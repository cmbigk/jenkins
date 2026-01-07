#!/bin/bash

# Rollback script for failed deployments
# Usage: ./rollback.sh <service-name> <previous-build-number>

SERVICE=$1
PREVIOUS_BUILD=$2

if [ -z "$SERVICE" ] || [ -z "$PREVIOUS_BUILD" ]; then
    echo "Usage: ./rollback.sh <service-name> <previous-build-number>"
    echo "Example: ./rollback.sh user-service 42"
    exit 1
fi

echo "========================================"
echo "Rolling back $SERVICE to build #$PREVIOUS_BUILD"
echo "========================================"

# Stop current container
docker stop $SERVICE
docker rm $SERVICE

# Start previous version
docker run -d \
    --name $SERVICE \
    --network buy-01_default \
    ecommerce/${SERVICE}:${PREVIOUS_BUILD}

# Health check
sleep 10
if curl -f http://localhost:8081/actuator/health; then
    echo "✅ Rollback successful!"
else
    echo "❌ Rollback failed - service is not healthy"
    exit 1
fi
