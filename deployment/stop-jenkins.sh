#!/bin/bash

echo "Stopping Jenkins CI/CD Server..."
docker-compose -f docker-compose.jenkins.yml down

echo "Jenkins has been stopped."
echo "To start again, run: ./start-jenkins.sh"
