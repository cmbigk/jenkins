#!/bin/bash

echo "Starting Jenkins CI/CD Server..."

# Create Jenkins data directory if it doesn't exist
mkdir -p jenkins-data

# Create network if it doesn't exist
docker network create buy-01_default 2>/dev/null || true

# Start Jenkins
docker-compose -f docker-compose.jenkins.yml up -d

echo ""
echo "======================================"
echo "Jenkins is starting up..."
echo "======================================"
echo "Jenkins UI will be available at: http://localhost:8090"
echo ""
echo "To get the initial admin password, run:"
echo "docker exec jenkins-ci cat /var/jenkins_home/secrets/initialAdminPassword"
echo ""
echo "To view Jenkins logs:"
echo "docker logs -f jenkins-ci"
echo ""
echo "To stop Jenkins:"
echo "docker-compose -f docker-compose.jenkins.yml down"
echo "======================================"
