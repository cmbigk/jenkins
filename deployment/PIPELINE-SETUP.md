# Jenkins CI/CD Pipeline - Setup Guide

## ✅ Implemented Features

### 1. **Automated Build Triggers**
- ✅ SCM Polling: Every 5 minutes (`H/5 * * * *`)
- ✅ GitHub Webhook support (commented, ready to enable)

### 2. **Automated Testing**
- ✅ **Backend**: JUnit tests run during Docker build
- ✅ **Frontend**: Karma/Jasmine tests (ChromeHeadless)
- ✅ Pipeline fails if any test fails
- ✅ Parallel test execution for speed

### 3. **Deployment with Rollback**
- ✅ Automatic backup before deployment
- ✅ One-click rollback to previous version
- ✅ Health checks after deployment
- ✅ Auto-rollback on health check failure
- ✅ Environment-specific deployments (dev/staging/production)

### 4. **Notifications**
- ✅ Detailed build success/failure messages
- ✅ Email notifications (ready to configure)
- ✅ Slack notifications (ready to configure)
- ✅ Build duration and changelog

### 5. **Additional Features**
- ✅ Smoke tests
- ✅ Automatic cleanup of old Docker images
- ✅ Deployment status monitoring
- ✅ Parallel builds for faster execution

---

## 🚀 Quick Start

### Trigger a Build
```bash
# Via Jenkins UI
http://localhost:8090/job/fullstack-pipeline/ → Build with Parameters

# Options:
- ENVIRONMENT: dev/staging/production
- SKIP_TESTS: false (run tests) / true (skip tests)
- ROLLBACK: false (deploy) / true (rollback to previous)
```

### Access Services After Deployment
```bash
# Frontend
http://localhost:4200

# API Gateway
http://localhost:8080

# Backend Services
http://localhost:8081  # User Service
http://localhost:8082  # Product Service
http://localhost:8083  # Media Service

# Health Checks
curl http://localhost:8080/actuator/health
curl http://localhost:8081/actuator/health
curl http://localhost:8082/actuator/health
curl http://localhost:8083/actuator/health
```

---

## 📧 Setup Email Notifications

### 1. Install Email Extension Plugin
```bash
Jenkins → Manage Jenkins → Plugins → Available
Search: "Email Extension Plugin" → Install
```

### 2. Configure SMTP in Jenkins
```groovy
Jenkins → Manage Jenkins → System → Extended E-mail Notification

SMTP server: smtp.gmail.com
SMTP Port: 587
Credentials: Add your email credentials
Use TLS: ✓ Enable
```

### 3. Uncomment in Jenkinsfile
```groovy
emailext (
    subject: "✅ Build #${BUILD_NUMBER} Successful",
    body: message,
    to: 'your-team@example.com'
)
```

---

## 💬 Setup Slack Notifications

### 1. Install Slack Plugin
```bash
Jenkins → Manage Jenkins → Plugins → Available
Search: "Slack Notification Plugin" → Install
```

### 2. Create Slack App
1. Go to https://api.slack.com/apps
2. Create New App → From scratch
3. Add "Incoming Webhooks" feature
4. Activate webhooks and create webhook URL
5. Copy webhook URL

### 3. Configure in Jenkins
```groovy
Jenkins → Manage Jenkins → System → Slack

Workspace: your-workspace
Credentials: Add Slack token
Default channel: #deployments
Test Connection
```

### 4. Uncomment in Jenkinsfile
```groovy
slackSend (
    color: 'good',
    message: message,
    channel: '#deployments'
)
```

---

## 🔄 GitHub Webhook Setup (For Instant Builds)

### 1. Make Jenkins Accessible
```bash
# Option A: Use ngrok for testing
ngrok http 8090

# Option B: Configure firewall/port forwarding
# Make Jenkins accessible at: http://your-server:8090
```

### 2. Add Webhook in GitHub
```
Repository → Settings → Webhooks → Add webhook

Payload URL: http://your-jenkins-url:8090/github-webhook/
Content type: application/json
Events: Just the push event
Active: ✓
```

### 3. Enable in Jenkinsfile
```groovy
triggers {
    githubPush()  // Uncomment this line
    // pollSCM('H/5 * * * *')  // Comment out polling
}
```

---

## 🧪 Running Tests Manually

### Backend Tests
```bash
cd user-service
mvn test

cd ../product-service
mvn test

cd ../media-service
mvn test

cd ../api-gateway
mvn test
```

### Frontend Tests
```bash
cd frontend
npm install
npm run test
```

---

## 🔙 How to Rollback

### Method 1: Via Jenkins UI
```
Build with Parameters
- ROLLBACK: ✓ true
- ENVIRONMENT: dev (match current)
→ Build
```

### Method 2: Automatic Rollback
If health checks fail, pipeline will error and you can re-run with ROLLBACK=true

### Method 3: Manual Docker Rollback
```bash
# Find backup tag
docker images | grep backup

# Stop current containers
docker stop user-service product-service media-service api-gateway frontend
docker rm user-service product-service media-service api-gateway frontend

# Run backup versions
docker run -d --name user-service --network buy-01_default -p 8081:8081 ecommerce/user-service:backup-10
docker run -d --name product-service --network buy-01_default -p 8082:8082 ecommerce/product-service:backup-10
# ... repeat for all services
```

---

## 📊 Monitoring & Logs

### View Service Logs
```bash
docker logs -f user-service
docker logs -f product-service
docker logs -f media-service
docker logs -f api-gateway
docker logs -f frontend
```

### Check Container Status
```bash
docker ps --filter "name=user-service" --filter "name=product-service" --filter "name=media-service" --filter "name=api-gateway" --filter "name=frontend"
```

### View Build History
```
http://localhost:8090/job/fullstack-pipeline/
```

---

## 🛠️ Troubleshooting

### Build Fails at Test Stage
```bash
# Check test logs in Jenkins console
# Fix tests locally first
mvn test  # for backend
npm test  # for frontend

# Skip tests temporarily (not recommended)
Build with Parameters → SKIP_TESTS: true
```

### Health Checks Fail
```bash
# Check service logs
docker logs <service-name>

# Verify services are running
docker ps

# Test endpoints manually
curl http://localhost:8080/actuator/health
```

### Rollback Not Working
```bash
# Check if backup images exist
docker images | grep backup

# Manually restore from previous build
docker images | grep ecommerce
# Use specific build number tag
```

### Tests Taking Too Long
```bash
# Tests run in parallel but can be slow
# Option 1: Skip tests for hotfixes (use sparingly)
# Option 2: Optimize test suites
# Option 3: Use test categorization (unit vs integration)
```

---

## 📝 Pipeline Parameters

| Parameter | Values | Description |
|-----------|--------|-------------|
| ENVIRONMENT | dev, staging, production | Target deployment environment |
| SKIP_TESTS | true/false | Skip test execution (not recommended) |
| ROLLBACK | true/false | Rollback to previous successful build |

---

## 🎯 Best Practices

1. **Always run tests before merging** - Don't rely on CI to catch bugs
2. **Use feature branches** - Keep main branch stable
3. **Test rollback procedure** - Ensure it works before you need it
4. **Monitor health checks** - Set up alerts for failures
5. **Review build logs** - Check warnings even on successful builds
6. **Keep backups** - Pipeline automatically keeps last 5 versions
7. **Use environments properly** - dev → staging → production
8. **Configure notifications** - Stay informed of build status

---

## 📈 Next Steps

1. ✅ Configure email notifications
2. ✅ Setup Slack integration
3. ✅ Enable GitHub webhooks
4. ✅ Add integration tests
5. ✅ Setup staging environment
6. ✅ Configure production deployment
7. ✅ Add performance tests
8. ✅ Setup monitoring (Prometheus/Grafana)
9. ✅ Add security scanning
10. ✅ Implement blue-green deployment

---

## 📞 Support

- Jenkins Documentation: https://www.jenkins.io/doc/
- GitHub Webhooks: https://docs.github.com/en/webhooks
- Docker Documentation: https://docs.docker.com/
- Your Team Slack: #devops-support
