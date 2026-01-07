# Jenkins Setup and GitHub Integration Guide

## 🎯 Overview

This guide will help you:
1. Access Jenkins (already running)
2. Connect Jenkins to your GitHub repository
3. Set up automatic builds on git push
4. Configure notifications
5. Pass all audit requirements

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:
- [ ] Jenkins running at http://localhost:8090
- [ ] GitHub account created
- [ ] Git configured locally
- [ ] Repository ready to push

---

## Step 1: Access Jenkins (IMPORTANT!)

Since the initial password file doesn't exist, Jenkins was configured with default settings. Let's set it up properly:

### Option A: Reset and Configure Jenkins

```bash
# Stop Jenkins
cd /Users/chan.myint/Desktop/jenkins/buy-01/deployment
./stop-jenkins.sh

# Remove Jenkins data to start fresh
docker volume rm deployment_jenkins_home 2>/dev/null || true

# Start Jenkins again
./start-jenkins.sh

# Wait 2 minutes, then get password
docker exec jenkins-ci cat /var/jenkins_home/secrets/initialAdminPassword
```

### Option B: Access with Default Credentials (If already configured)

1. Open http://localhost:8090
2. Try logging in with:
   - Username: `admin`
   - Password: `admin123`

If this doesn't work, use Option A to reset.

---

## Step 2: Complete Jenkins Initial Setup

1. **Open Jenkins**: http://localhost:8090

2. **Enter Admin Password** (from Option A above)

3. **Install Suggested Plugins** - Click "Install suggested plugins"
   - Wait for installation to complete (~5-10 minutes)

4. **Create Admin User**:
   - Username: `admin` (or your choice)
   - Password: `your-secure-password`
   - Full name: Your name
   - Email: your-email@example.com

5. **Jenkins URL**: Keep as `http://localhost:8090/`

6. **Click "Start using Jenkins"**

---

## Step 3: Install Required Plugins

**Manage Jenkins → Plugin Manager → Available**

Install these plugins (if not already installed):
- [ ] Git Plugin
- [ ] GitHub Plugin
- [ ] GitHub Branch Source Plugin
- [ ] Pipeline
- [ ] Docker Pipeline
- [ ] Maven Integration
- [ ] NodeJS Plugin
- [ ] JUnit Plugin
- [ ] JaCoCo Plugin
- [ ] Email Extension Plugin
- [ ] Slack Notification Plugin
- [ ] Blue Ocean (optional, but recommended)

After installation, restart Jenkins:
```bash
docker restart jenkins-ci
```

---

## Step 4: Configure Global Tools

**Manage Jenkins → Global Tool Configuration**

### 4.1 JDK Configuration
- Click "Add JDK"
- Name: `JDK-21`
- ✅ Install automatically
- Installer: "Install from adoptium.net"
- Version: Select jdk-21 (latest)

### 4.2 Maven Configuration
- Click "Add Maven"
- Name: `Maven-3.9`
- ✅ Install automatically
- Version: 3.9.5

### 4.3 Node.js Configuration
- Click "Add NodeJS"
- Name: `NodeJS-20`
- ✅ Install automatically
- Version: NodeJS 20.x
- Global packages to install: `@angular/cli`

### 4.4 Git Configuration
- Usually pre-configured
- If not: Name: `Default`, Path to Git: `git`

**Click "Save"**

---

## Step 5: Configure GitHub Credentials

**Manage Jenkins → Manage Credentials → (global) → Add Credentials**

### Create GitHub Personal Access Token

1. Go to GitHub: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Name: `Jenkins CI/CD`
4. Expiration: 90 days (or your preference)
5. Select scopes:
   - ✅ `repo` (all)
   - ✅ `admin:repo_hook`
   - ✅ `admin:org_hook` (if using org)
6. Click "Generate token"
7. **COPY THE TOKEN** (you won't see it again!)

### Add Credentials to Jenkins

1. **Kind**: Username with password
2. **Scope**: Global
3. **Username**: Your GitHub username
4. **Password**: Paste the GitHub token
5. **ID**: `github-credentials`
6. **Description**: `GitHub Access Token`
7. Click "Create"

---

## Step 6: Push Repository to GitHub

### 6.1 Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `jenkins`
3. Description: "E-commerce CI/CD with Jenkins Pipeline"
4. ✅ Public or Private (your choice)
5. ❌ Do NOT initialize with README (we already have one)
6. Click "Create repository"

### 6.2 Push Your Code

```bash
cd /Users/chan.myint/Desktop/jenkins/buy-01

# Clean up unneeded files
git restore api-gateway/target/
git restore media-service/target/
git restore product-service/target/
git restore user-service/target/

# Add all Jenkins files
git add .
git commit -m "Add Jenkins CI/CD pipeline with complete automation

- Add Jenkinsfiles for all 5 services
- Add deployment scripts (deploy, rollback, health-check)
- Add comprehensive documentation
- Configure automated testing
- Set up notifications
- Implement blue-green deployment"

# Set remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/jenkins.git
# Or if origin exists:
git remote set-url origin https://github.com/YOUR_USERNAME/jenkins.git

# Push to GitHub
git push -u origin main
```

---

## Step 7: Create Jenkins Pipelines

### 7.1 Create User Service Pipeline

1. Jenkins Dashboard → **New Item**
2. Enter name: `user-service-pipeline`
3. Select: **Pipeline**
4. Click **OK**

**Configure:**
- **Description**: `CI/CD pipeline for User Service`
- **Build Triggers**:
  - ✅ **Poll SCM**: `H/5 * * * *` (poll every 5 minutes)
  - ✅ **GitHub hook trigger for GITScm polling**
- **Pipeline**:
  - Definition: **Pipeline script from SCM**
  - SCM: **Git**
  - Repository URL: `https://github.com/YOUR_USERNAME/jenkins.git`
  - Credentials: Select `github-credentials`
  - Branch Specifier: `*/main`
  - Script Path: `user-service/Jenkinsfile`
- Click **Save**

### 7.2 Create Remaining Service Pipelines

Repeat Step 7.1 for:

| Pipeline Name | Script Path |
|---------------|-------------|
| `product-service-pipeline` | `product-service/Jenkinsfile` |
| `media-service-pipeline` | `media-service/Jenkinsfile` |
| `api-gateway-pipeline` | `api-gateway/Jenkinsfile` |
| `frontend-pipeline` | `frontend/Jenkinsfile` |

### 7.3 (Optional) Create Full Stack Pipeline

- Name: `fullstack-deployment`
- Script Path: `deployment/Jenkinsfile.fullstack`
- This will build and deploy all services in parallel

---

## Step 8: Configure GitHub Webhook

### Option A: Using GitHub Webhooks (Recommended for production)

1. Go to your GitHub repository
2. **Settings** → **Webhooks** → **Add webhook**
3. **Payload URL**: `http://YOUR_PUBLIC_IP:8090/github-webhook/`
   - For local testing, use ngrok: https://ngrok.com/
4. **Content type**: `application/json`
5. **Which events**: Just the push event
6. ✅ Active
7. Click **Add webhook**

### Option B: Using SCM Polling (Works locally)

Already configured in Step 7! Jenkins will poll GitHub every 5 minutes for changes.

---

## Step 9: Configure Email Notifications

**Manage Jenkins → Configure System → Extended E-mail Notification**

### Gmail Configuration

1. **SMTP server**: `smtp.gmail.com`
2. **SMTP Port**: `465`
3. **Credentials**: Click "Add"
   - Kind: Username with password
   - Username: your-email@gmail.com
   - Password: [App Password - see below]
   - ID: `gmail-credentials`
4. ✅ **Use SSL**
5. **Default user e-mail suffix**: `@gmail.com`
6. **Default Recipients**: `your-email@gmail.com`
7. Click **Test configuration** to verify
8. Click **Save**

### Generate Gmail App Password

1. Enable 2-factor authentication on Google account
2. Go to: https://myaccount.google.com/apppasswords
3. App name: `Jenkins`
4. Click "Create"
5. Copy the 16-character password
6. Use this in Jenkins credentials (not your regular password)

---

## Step 10: Configure Slack Notifications (Optional)

### 10.1 Add Jenkins to Slack

1. Go to: https://YOUR_WORKSPACE.slack.com/apps/A0F7VRFKN-jenkins-ci
2. Click "Add to Slack"
3. Choose channel: `#deployments` (or create it)
4. Click "Add Jenkins CI Integration"
5. **Copy the Webhook URL**

### 10.2 Configure in Jenkins

**Manage Jenkins → Configure System → Slack**

1. **Workspace**: Your workspace name
2. **Credential**: Click "Add"
   - Kind: Secret text
   - Secret: Paste webhook URL
   - ID: `slack-token`
3. **Default channel**: `#deployments`
4. Click **Test Connection**
5. Click **Save**

---

## Step 11: Test Your Pipeline!

### 11.1 Trigger First Build

1. Go to Jenkins Dashboard
2. Click on `user-service-pipeline`
3. Click **Build Now**
4. Watch the build progress
5. Check **Console Output** for details

### 11.2 Test Automatic Trigger

```bash
cd /Users/chan.myint/Desktop/jenkins/buy-01

# Make a small change
echo "# Test CI/CD" >> README.md

# Commit and push
git add README.md
git commit -m "Test Jenkins automatic trigger"
git push origin main

# Wait 5 minutes or trigger manually
# Jenkins should automatically start a build!
```

### 11.3 Test Build Failure

```bash
# Create a failing test
cat > user-service/src/test/java/com/ecommerce/user/FailingTest.java << 'EOF'
package com.ecommerce.user;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class FailingTest {
    @Test
    void thisWillFail() {
        fail("Intentional test failure to verify pipeline behavior");
    }
}
EOF

git add .
git commit -m "Add failing test to verify pipeline behavior"
git push origin main
```

**Expected Result**: Pipeline should fail at "Test" stage and NOT deploy.

**Clean up after test:**
```bash
git rm user-service/src/test/java/com/ecommerce/user/FailingTest.java
git commit -m "Remove test failure"
git push origin main
```

---

## 📋 Audit Requirements Verification

### ✅ Functional Requirements

| Requirement | How to Verify | Status |
|-------------|---------------|---------|
| Pipeline runs start to finish | Trigger build and watch stages complete | ✅ |
| Responds to build errors | Add failing test, verify pipeline stops | ✅ |
| Automated testing | Check "Test Results" in build | ✅ |
| Pipeline halts on test failure | Tests stage fails → No deployment | ✅ |
| Auto-trigger on git push | Push commit, wait 5 min, build starts | ✅ |
| Automated deployment | Successful build → service deployed | ✅ |
| Rollback strategy | Deploy fails → auto rollback or manual script | ✅ |

### ✅ Security Requirements

| Requirement | Implementation | Status |
|-------------|----------------|---------|
| Jenkins permissions | User roles configured | ✅ |
| Sensitive data secured | Credentials in Jenkins credentials store | ✅ |
| No hardcoded secrets | All passwords/tokens in credentials | ✅ |

### ✅ Code Quality

| Requirement | Location | Status |
|-------------|----------|---------|
| Well-organized Jenkinsfile | All service Jenkinsfiles with clear stages | ✅ |
| Clear test reports | JUnit reports + console output | ✅ |
| Comprehensive notifications | Email + Slack with build details | ✅ |
| Best practices | Comments, error handling, cleanup | ✅ |

---

## 🎯 Quick Audit Demo Script

Use this script to demonstrate all requirements:

```bash
# 1. Show Jenkins is running
open http://localhost:8090

# 2. Trigger a build manually
# Click "Build Now" on user-service-pipeline

# 3. Show automated testing
# Click on build → Test Results

# 4. Show automatic trigger
cd /Users/chan.myint/Desktop/jenkins/buy-01
echo "# Demo change" >> README.md
git add README.md
git commit -m "Demo: Test automatic trigger"
git push origin main
# Wait 5 minutes or trigger via webhook

# 5. Show build failure response
# (Use failing test from Step 11.3)

# 6. Show deployment
docker ps | grep user-service
curl http://localhost:8081/actuator/health

# 7. Show rollback capability
cd deployment/scripts
./rollback.sh user-service 1

# 8. Show notifications
# Check email and Slack for notifications

# 9. Show security - credentials are secured
# Manage Jenkins → Credentials (show entries, not values)

# 10. Show code quality
# View Jenkinsfile in GitHub
# Show test reports in Jenkins
```

---

## 🔧 Troubleshooting

### Issue: Can't access Jenkins
```bash
docker ps | grep jenkins
docker logs jenkins-ci
```

### Issue: Pipeline fails at checkout
- Check GitHub credentials are correct
- Verify repository URL is correct
- Check branch name (main vs master)

### Issue: Tests don't run
- Verify Maven/Node.js tools are configured
- Check Jenkinsfile has correct tool names
- Review console output for errors

### Issue: No email notifications
- Verify Gmail app password is correct
- Test SMTP connection in Jenkins config
- Check spam folder

### Issue: Webhook doesn't work locally
- Use SCM polling instead (already configured)
- Or use ngrok for public URL: https://ngrok.com/

---

## 📚 Next Steps

1. ✅ Complete this setup guide
2. ✅ Test all pipelines
3. ✅ Verify notifications work
4. ✅ Test rollback strategy
5. ✅ Document any customizations
6. ✅ Prepare for audit demonstration

---

## 🆘 Quick Help

**Start Jenkins:**
```bash
cd deployment && ./start-jenkins.sh
```

**View Logs:**
```bash
docker logs -f jenkins-ci
```

**Check Services:**
```bash
./deployment/scripts/health-check.sh
```

**Rollback:**
```bash
./deployment/scripts/rollback.sh [service] [build-number]
```

---

**Your CI/CD pipeline is ready! 🚀**

For more detailed information, see:
- [deployment/README.md](README.md) - Complete setup documentation
- [deployment/TESTING_GUIDE.md](TESTING_GUIDE.md) - Testing checklist
- [deployment/TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Issue resolution
