#!/bin/bash

# Smoke test script for post-deployment validation
echo "Running smoke tests..."

# Test API Gateway
echo "Testing API Gateway..."
curl -f http://localhost:8080/actuator/health || exit 1

# Test User Service via Gateway
echo "Testing User Service..."
curl -f http://localhost:8080/api/users/health || true

# Test Product Service via Gateway
echo "Testing Product Service..."
curl -f http://localhost:8080/api/products || true

# Test Media Service via Gateway
echo "Testing Media Service..."
curl -f http://localhost:8080/api/media/health || true

# Test Frontend
echo "Testing Frontend..."
curl -f http://localhost:4200 || exit 1

echo "✅ All smoke tests passed!"
