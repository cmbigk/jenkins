# Quick Start Guide - Jenkins CI/CD

## 🚀 Get Started in 5 Minutes

### Step 1: Start Jenkins
```bash
cd deployment
./start-jenkins.sh
```

### Step 2: Access Jenkins
Open: **http://localhost:8090**

Get password:
```bash
docker exec jenkins-ci cat /var/jenkins_home/secrets/initialAdminPassword
```

### Step 3: Complete Setup
1. Enter admin password
2. Install suggested plugins
3. Create admin user
4. Start using Jenkins!

### Step 4: Create Your First Pipeline

1. Click **New Item**
2. Name: `user-service-pipeline`
3. Type: **Pipeline**
4. Configure:
   - SCM: Git
   - Repository: [Your Git URL]
   - Script Path: `user-service/Jenkinsfile`
5. Save & Build!

---

## 📁 Project Structure

```
deployment/
├── docker-compose.jenkins.yml   # Jenkins container setup
├── start-jenkins.sh              # Start Jenkins script
├── stop-jenkins.sh               # Stop Jenkins script
├── Jenkinsfile.fullstack         # Full deployment pipeline
├── scripts/
│   ├── deploy.sh                 # Deployment script
│   ├── rollback.sh               # Rollback script
│   ├── health-check.sh           # Health check script
│   └── smoke-tests.sh            # Smoke tests
└── README.md                     # Full documentation

Each Service:
├── Jenkinsfile                   # Service-specific pipeline
├── Dockerfile                    # Docker build
└── pom.xml / package.json        # Build config
```

---

## 🎯 Common Tasks

### Build a Service
```bash
# Trigger via UI or:
curl -X POST http://localhost:8090/job/user-service-pipeline/build
```

### Check Service Health
```bash
./deployment/scripts/health-check.sh
```

### Rollback Deployment
```bash
./deployment/scripts/rollback.sh user-service 42
```

### View Logs
```bash
docker logs -f jenkins-ci
```

---

## 📊 Pipeline Features

✅ Automatic Git polling (every 5 minutes)  
✅ Automated testing (JUnit + Jasmine/Karma)  
✅ Docker image building  
✅ Blue-green deployment  
✅ Automated rollback on failure  
✅ Email & Slack notifications  
✅ Code coverage reports  
✅ Parameterized builds  
✅ Parallel execution  

---

## 🔧 Configuration Checklist

After Jenkins is running, configure:

1. **Tools** (Manage Jenkins → Global Tool Configuration)
   - [ ] JDK 21
   - [ ] Maven 3.9
   - [ ] NodeJS 20

2. **Credentials** (Manage Jenkins → Credentials)
   - [ ] GitHub token
   - [ ] Docker Hub (optional)
   - [ ] Slack webhook

3. **Email** (Manage Jenkins → Configure System)
   - [ ] SMTP server settings
   - [ ] Default recipients

4. **Create Pipelines**
   - [ ] user-service-pipeline
   - [ ] product-service-pipeline
   - [ ] media-service-pipeline
   - [ ] api-gateway-pipeline
   - [ ] frontend-pipeline
   - [ ] fullstack-deployment (optional)

---

## 📚 Full Documentation

See [README.md](README.md) for:
- Detailed setup instructions
- Configuration guides
- Testing setup
- Deployment strategies
- Troubleshooting
- Best practices

---

## 🆘 Quick Help

**Jenkins not starting?**
```bash
docker logs jenkins-ci
```

**Permission denied?**
```bash
chmod +x deployment/*.sh deployment/scripts/*.sh
```

**Can't access Jenkins?**
- Check http://localhost:8090
- Ensure port 8090 is free

**Build failing?**
- Check console output in Jenkins UI
- Verify all tools are configured
- Check Docker is running

---

**Questions?** Check the full [README.md](README.md)
