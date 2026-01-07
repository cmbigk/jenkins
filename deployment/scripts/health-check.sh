#!/bin/bash

# Health check script for all services
echo "Checking health of all microservices..."

SERVICES=(
    "api-gateway:8080"
    "user-service:8081"
    "product-service:8082"
    "media-service:8083"
    "frontend:4200"
)

ALL_HEALTHY=true

for service in "${SERVICES[@]}"; do
    NAME="${service%%:*}"
    PORT="${service##*:}"
    
    echo -n "Checking $NAME... "
    
    if curl -f -s http://localhost:$PORT/actuator/health > /dev/null 2>&1 || \
       curl -f -s http://localhost:$PORT > /dev/null 2>&1; then
        echo "✅ HEALTHY"
    else
        echo "❌ UNHEALTHY"
        ALL_HEALTHY=false
    fi
done

if [ "$ALL_HEALTHY" = true ]; then
    echo ""
    echo "✅ All services are healthy!"
    exit 0
else
    echo ""
    echo "❌ Some services are unhealthy!"
    exit 1
fi
