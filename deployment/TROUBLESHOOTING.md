# Jenkins CI/CD Troubleshooting Guide

## 🔍 Common Issues and Solutions

### 1. Jenkins Won't Start

#### Symptom
```bash
./start-jenkins.sh
# Nothing happens or error message
```

#### Solutions

**Check if port 8090 is already in use:**
```bash
lsof -i :8090
# If something is using it:
kill -9 [PID]
```

**Check Docker is running:**
```bash
docker ps
# If error, start Docker Desktop
```

**Check Docker Compose:**
```bash
cd deployment
docker-compose -f docker-compose.jenkins.yml up -d
docker logs jenkins-ci
```

**Permissions issue:**
```bash
chmod +x start-jenkins.sh
chmod +x stop-jenkins.sh
```

---

### 2. Can't Access Jenkins UI

#### Symptom
http://localhost:8090 shows "Connection Refused"

#### Solutions

**Check Jenkins container status:**
```bash
docker ps -a | grep jenkins
```

**If container is not running:**
```bash
docker start jenkins-ci
```

**If container is restarting:**
```bash
docker logs jenkins-ci
# Check for errors
```

**Check port mapping:**
```bash
docker port jenkins-ci
# Should show: 8080/tcp -> 0.0.0.0:8090
```

---

### 3. Pipeline Fails at Checkout Stage

#### Symptom
```
ERROR: Failed to clone repository
```

#### Solutions

**Check Git credentials:**
1. Manage Jenkins → Manage Credentials
2. Verify GitHub credentials exist
3. Test with: `git clone [your-repo]`

**Update repository URL:**
- Use HTTPS: `https://github.com/user/repo.git`
- Or SSH: `git@github.com:user/repo.git`

**Check Jenkins has Git:**
```bash
docker exec jenkins-ci git --version
```

---

### 4. Maven Build Fails

#### Symptom
```
mvn: command not found
```

#### Solutions

**Configure Maven in Jenkins:**
1. Manage Jenkins → Global Tool Configuration
2. Maven → Add Maven
3. Name: `Maven-3.9`
4. Install automatically: ✅

**Update Jenkinsfile:**
```groovy
tools {
    maven 'Maven-3.9'
    jdk 'JDK-21'
}
```

**Check Maven in container:**
```bash
docker exec jenkins-ci mvn --version
```

---

### 5. Tests Fail in Jenkins but Pass Locally

#### Symptom
```
Tests run: 10, Failures: 3
```

#### Common Causes

**Different Java versions:**
```bash
# Local
java --version

# Jenkins
docker exec jenkins-ci java --version
```

**Missing test dependencies:**
Check `pom.xml` has all test dependencies

**Database not available:**
```yaml
# Add to docker-compose.jenkins.yml
services:
  test-db:
    image: postgres:15
    environment:
      POSTGRES_DB: testdb
```

**Environment variables missing:**
```groovy
// Add to Jenkinsfile
environment {
    DB_URL = 'jdbc:postgresql://test-db:5432/testdb'
}
```

---

### 6. Docker Build Fails

#### Symptom
```
docker: command not found
```

#### Solutions

**Verify Docker socket is mounted:**
```bash
docker exec jenkins-ci ls -la /var/run/docker.sock
```

**If not found, update docker-compose.jenkins.yml:**
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

**Check Docker client in Jenkins:**
```bash
docker exec jenkins-ci docker ps
```

**Permissions issue:**
```bash
docker exec jenkins-ci chmod 666 /var/run/docker.sock
```

---

### 7. Deployment Fails

#### Symptom
```
Error: Container name already in use
```

#### Solutions

**Stop and remove existing container:**
```bash
docker stop user-service
docker rm user-service
```

**Update Jenkinsfile to handle this:**
```groovy
sh """
    docker stop ${SERVICE_NAME} 2>/dev/null || true
    docker rm ${SERVICE_NAME} 2>/dev/null || true
"""
```

**Check network exists:**
```bash
docker network ls | grep buy-01_default
# If not exists:
docker network create buy-01_default
```

---

### 8. Health Check Fails

#### Symptom
```
curl: (7) Failed to connect to localhost port 8081
```

#### Solutions

**Service not ready yet:**
```groovy
// Add longer wait time
sleep(time: 30, unit: 'SECONDS')
```

**Wrong port:**
```bash
# Check which port service is using
docker port user-service
```

**Service crashed:**
```bash
docker logs user-service
# Check for errors
```

**Actuator not enabled:**
```xml
<!-- Add to pom.xml -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

---

### 9. No Email Notifications

#### Symptom
No emails received after builds

#### Solutions

**Test SMTP connection:**
1. Manage Jenkins → Configure System
2. Extended E-mail Notification → Test Configuration

**Gmail specific setup:**
```
SMTP server: smtp.gmail.com
SMTP port: 465
Use SSL: ✅
Username: your-email@gmail.com
Password: [App Password, not regular password]
```

**Generate Gmail App Password:**
1. https://myaccount.google.com/apppasswords
2. Enable 2-factor auth first
3. Generate app password
4. Use in Jenkins

**Check email in spam:**
Check spam/junk folder

**Verify recipient:**
```groovy
// In post section
emailext(
    to: 'your-email@example.com',  // Change this!
    ...
)
```

---

### 10. Slack Notifications Not Working

#### Symptom
No Slack messages after builds

#### Solutions

**Test connection:**
1. Manage Jenkins → Configure System
2. Slack → Test Connection

**Get correct webhook:**
1. Go to: https://[workspace].slack.com/apps/A0F7VRFKN-jenkins-ci
2. Add to channel
3. Copy webhook URL

**Update credentials:**
1. Manage Jenkins → Credentials
2. Add Secret text with webhook URL
3. Use ID: `slack-token`

**Check channel exists:**
- Verify #deployments channel exists
- Jenkins app is in the channel

---

### 11. Pipeline is Very Slow

#### Symptom
Build takes > 20 minutes

#### Solutions

**Enable parallel stages:**
```groovy
stages {
    stage('Parallel Tasks') {
        parallel {
            stage('Build') { ... }
            stage('Lint') { ... }
        }
    }
}
```

**Cache dependencies:**
```groovy
// Maven
sh 'mvn dependency:go-offline'

// npm
sh 'npm ci --cache .npm'
```

**Use Docker layer caching:**
```dockerfile
# Put dependencies first (changes less often)
COPY pom.xml .
RUN mvn dependency:go-offline

# Then copy code (changes more often)
COPY src ./src
```

**Reduce test scope:**
```bash
# Skip integration tests for quick builds
mvn test -DskipITs
```

---

### 12. Out of Disk Space

#### Symptom
```
No space left on device
```

#### Solutions

**Clean old Docker images:**
```bash
docker system prune -a
docker volume prune
```

**Clean Jenkins workspace:**
```bash
docker exec jenkins-ci rm -rf /var/jenkins_home/workspace/*
```

**Clean old builds:**
1. Configure pipeline
2. Discard old builds: Keep last 10 builds

**Add cleanup to Jenkinsfile:**
```groovy
post {
    always {
        cleanWs()
    }
}
```

---

### 13. Permission Denied Errors

#### Symptom
```
permission denied: /deployment/scripts/deploy.sh
```

#### Solutions

**Fix file permissions:**
```bash
chmod +x deployment/scripts/*.sh
git add deployment/scripts/*.sh
git commit -m "Fix permissions"
git push
```

**In Jenkinsfile:**
```groovy
sh 'chmod +x deployment/scripts/deploy.sh'
sh './deployment/scripts/deploy.sh'
```

---

### 14. Node.js/npm Issues

#### Symptom
```
npm: command not found
```

#### Solutions

**Configure Node.js in Jenkins:**
1. Manage Jenkins → Global Tool Configuration
2. NodeJS → Add NodeJS
3. Name: `NodeJS-20`
4. Version: 20.x
5. Global packages: `@angular/cli`

**Update Jenkinsfile:**
```groovy
tools {
    nodejs 'NodeJS-20'
}
```

**Install Angular CLI:**
```bash
docker exec jenkins-ci npm install -g @angular/cli
```

---

### 15. Rollback Doesn't Work

#### Symptom
```
Error: No such image: ecommerce/user-service:42
```

#### Solutions

**Check available images:**
```bash
docker images | grep ecommerce
```

**Images not retained:**
- Don't use `docker system prune -a`
- Configure pipeline to keep images

**Manual rollback:**
```bash
# Find previous running container
docker ps -a | grep user-service

# Start old container
docker start [container-id]
```

---

## 🔧 Debugging Commands

### Check Jenkins Status
```bash
# Container status
docker ps | grep jenkins

# Jenkins logs
docker logs -f jenkins-ci

# Enter Jenkins container
docker exec -it jenkins-ci bash
```

### Check Services
```bash
# All containers
docker ps

# Service logs
docker logs user-service
docker logs product-service

# Service health
curl http://localhost:8081/actuator/health
```

### Check Builds
```bash
# Jenkins workspace
docker exec jenkins-ci ls -la /var/jenkins_home/workspace/

# Build artifacts
docker exec jenkins-ci ls -la /var/jenkins_home/workspace/user-service-pipeline/user-service/target/
```

### Check Network
```bash
# Networks
docker network ls

# Services in network
docker network inspect buy-01_default
```

---

## 📝 Diagnostic Checklist

When encountering an issue:

1. [ ] Check Jenkins logs: `docker logs jenkins-ci`
2. [ ] Check service logs: `docker logs [service-name]`
3. [ ] Check Jenkins UI console output
4. [ ] Verify Docker is running: `docker ps`
5. [ ] Check disk space: `df -h`
6. [ ] Verify network: `docker network ls`
7. [ ] Check ports: `lsof -i :[port]`
8. [ ] Review Jenkinsfile syntax
9. [ ] Test locally: Run build commands manually
10. [ ] Check credentials and configurations

---

## 🆘 Getting Help

### Jenkins Console Output
Always check console output first:
http://localhost:8090/job/[pipeline-name]/[build-number]/console

### Verbose Logging
Enable in Jenkinsfile:
```groovy
options {
    timestamps()
    ansiColor('xterm')
}
```

### Jenkins System Log
Manage Jenkins → System Log

### Docker Logs
```bash
docker logs jenkins-ci --tail 100 -f
```

---

## 📚 Additional Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Maven Troubleshooting](https://maven.apache.org/troubleshooting.html)
- [Spring Boot Actuator](https://docs.spring.io/spring-boot/docs/current/reference/html/actuator.html)

---

**Still stuck? Check the main [README.md](README.md) for more information!**
