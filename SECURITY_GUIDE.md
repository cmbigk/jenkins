# Jenkins Security Configuration Guide

## Quick Security Setup

### 1. Change Admin Password (IMMEDIATE)

```bash
# Access Jenkins UI
open http://localhost:8090

# Go to: Manage Jenkins > Manage Users > admin > Configure
# Change password from 'admin123' to a strong password
# Minimum 12 characters, mixed case, numbers, symbols
```

### 2. Enable Security Realm

**Via Jenkins UI:**
1. Manage Jenkins → Configure Global Security
2. Security Realm: Select "Jenkins' own user database"
3. Authorization: Select "Matrix-based security"
4. Add users with specific permissions

### 3. Configure Credentials Store

**Add GitHub Credentials:**
```bash
# In Jenkins UI:
# Manage Jenkins > Manage Credentials > (global) > Add Credentials

# Type: Username with password
# Username: your-github-username
# Password: your-github-personal-access-token
# ID: github-credentials
# Description: GitHub Access Token
```

**Add Docker Hub Credentials:**
```bash
# Type: Username with password
# Username: your-dockerhub-username
# Password: your-dockerhub-token
# ID: docker-hub-credentials
```

### 4. Update Jenkinsfile to Use Credentials

Add to Jenkinsfile environment section:
```groovy
environment {
    PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    DOCKER_NETWORK = "buy-01_default"
    BACKUP_TAG = "backup-${BUILD_NUMBER}"
    
    // Use credentials securely
    GITHUB_CREDS = credentials('github-credentials')
    DOCKER_CREDS = credentials('docker-hub-credentials')
}
```

### 5. Set Up Role-Based Access

**Recommended Roles:**

| Role | Permissions | Users |
|------|-------------|-------|
| **Admin** | Overall/Administer | DevOps Lead |
| **Developer** | Job/Build, Job/Read, Job/Workspace | Dev Team |
| **QA** | Job/Read, Job/Cancel | QA Team |
| **Viewer** | Job/Read | Stakeholders |

### 6. Enable Audit Logging

Add to `jenkins.yaml`:
```yaml
jenkins:
  systemMessage: "Production Jenkins - All actions are logged"
  
  globalNodeProperties:
    - envVars:
        env:
          - key: AUDIT_ENABLED
            value: "true"
```

### 7. Secure Jenkins Configuration Files

```bash
# Restrict access to Jenkins configuration
chmod 600 /var/jenkins_home/config.xml
chmod 600 /var/jenkins_home/credentials.xml

# In docker-compose.jenkins.yml, mount secrets securely
volumes:
  - jenkins-data:/var/jenkins_home
  - ./secrets:/var/jenkins_home/secrets:ro  # Read-only secrets
```

## Environment Variables Best Practices

### Development Environment
```groovy
environment {
    ENV_NAME = 'development'
    DB_HOST = 'localhost'
    DB_PORT = '5432'
    DB_NAME = 'ecommerce_dev'
    DB_USER = credentials('dev-db-user')
    DB_PASS = credentials('dev-db-password')
    SSL_ENABLED = 'false'
}
```

### Production Environment
```groovy
environment {
    ENV_NAME = 'production'
    DB_HOST = credentials('prod-db-host')
    DB_PORT = '5432'
    DB_NAME = 'ecommerce_prod'
    DB_USER = credentials('prod-db-user')
    DB_PASS = credentials('prod-db-password')
    SSL_ENABLED = 'true'
    SSL_CERT = credentials('ssl-certificate')
}
```

## Notification Setup

### Email Notifications

1. **Configure SMTP in Jenkins:**
```bash
# Manage Jenkins > Configure System > Extended E-mail Notification
# SMTP server: smtp.gmail.com
# Port: 587
# Use TLS: Yes
# Credentials: Add email credentials
```

2. **Enable in Jenkinsfile:**
```groovy
post {
    success {
        emailext (
            subject: "✅ Build #${BUILD_NUMBER} Successful",
            body: "${message}",
            to: 'team@example.com',
            recipientProviders: [developers(), requestor()]
        )
    }
    failure {
        emailext (
            subject: "❌ Build #${BUILD_NUMBER} Failed",
            body: "${message}",
            to: 'team@example.com',
            recipientProviders: [developers(), requestor(), culprits()],
            attachLog: true
        )
    }
}
```

### Slack Notifications

1. **Install Plugin:**
```bash
# Manage Jenkins > Manage Plugins > Available
# Search: Slack Notification Plugin
# Install without restart
```

2. **Configure Slack:**
```bash
# Create Slack App at api.slack.com
# Add Incoming Webhook
# Copy Webhook URL to Jenkins:
# Manage Jenkins > Configure System > Slack
# Workspace: your-workspace
# Credential: Add Secret Text with webhook URL
# Default channel: #deployments
```

3. **Enable in Jenkinsfile:**
```groovy
post {
    success {
        slackSend (
            color: 'good',
            message: "✅ Build #${BUILD_NUMBER} deployed successfully\n${env.BUILD_URL}",
            channel: '#deployments'
        )
    }
    failure {
        slackSend (
            color: 'danger',
            message: "❌ Build #${BUILD_NUMBER} failed\n${env.BUILD_URL}console",
            channel: '#deployments'
        )
    }
}
```

## Security Checklist

- [ ] Admin password changed from default
- [ ] Security realm enabled
- [ ] Matrix-based authorization configured
- [ ] GitHub credentials stored securely
- [ ] Docker Hub credentials stored securely
- [ ] Database credentials stored securely
- [ ] Audit logging enabled
- [ ] Jenkins configuration files protected
- [ ] Email notifications configured
- [ ] Slack notifications configured
- [ ] SSL/TLS enabled for production
- [ ] Regular security updates scheduled
- [ ] Backup strategy in place
- [ ] Disaster recovery tested

## Monitoring & Alerts

### Set Up Health Monitoring

Add to Jenkinsfile:
```groovy
stage('Security Scan') {
    steps {
        script {
            // Scan Docker images for vulnerabilities
            sh 'docker scan ecommerce/user-service:${BUILD_NUMBER}'
            
            // Check for dependency vulnerabilities
            dir('user-service') {
                sh 'mvn dependency-check:check'
            }
            
            // Frontend security audit
            dir('frontend') {
                sh 'npm audit --production'
            }
        }
    }
}
```

### Configure Jenkins Monitoring Plugin

```bash
# Install Monitoring Plugin
# Manage Jenkins > Manage Plugins > Available
# Search: Monitoring
# Provides: CPU, Memory, Thread usage graphs
```

## Backup & Disaster Recovery

### Automated Jenkins Backup

Create backup script:
```bash
#!/bin/bash
# backup-jenkins.sh

BACKUP_DIR="/backups/jenkins"
DATE=$(date +%Y%m%d_%H%M%S)

# Backup Jenkins home
tar -czf "${BACKUP_DIR}/jenkins-home-${DATE}.tar.gz" \
    /var/jenkins_home/jobs \
    /var/jenkins_home/config.xml \
    /var/jenkins_home/credentials.xml \
    /var/jenkins_home/secrets

# Keep last 7 days
find "${BACKUP_DIR}" -name "jenkins-home-*.tar.gz" -mtime +7 -delete

echo "Backup completed: jenkins-home-${DATE}.tar.gz"
```

### Schedule Backup

Add to crontab:
```bash
# Daily backup at 2 AM
0 2 * * * /path/to/backup-jenkins.sh
```

## Production Deployment Checklist

Before deploying to production:

1. **Security**
   - [ ] Change all default passwords
   - [ ] Enable HTTPS/TLS
   - [ ] Configure firewall rules
   - [ ] Set up VPN access
   - [ ] Enable 2FA for admin accounts

2. **Monitoring**
   - [ ] Configure log aggregation
   - [ ] Set up alerting (PagerDuty, OpsGenie)
   - [ ] Enable performance monitoring
   - [ ] Configure uptime monitoring

3. **Compliance**
   - [ ] Document access controls
   - [ ] Enable audit logging
   - [ ] Set up log retention policy
   - [ ] Configure compliance reporting

4. **Operations**
   - [ ] Test rollback procedure
   - [ ] Document runbooks
   - [ ] Train operations team
   - [ ] Schedule maintenance windows

## Resources

- [Jenkins Security Documentation](https://www.jenkins.io/doc/book/security/)
- [Pipeline Best Practices](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/)
- [Securing Jenkins](https://www.jenkins.io/doc/book/security/securing-jenkins/)
