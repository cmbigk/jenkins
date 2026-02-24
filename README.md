# Jenkins CI/CD Pipeline for Microservices

[![Jenkins](https://img.shields.io/badge/Jenkins-Automated-red)]()
[![Docker](https://img.shields.io/badge/Docker-Compose-blue)]()
[![Java](https://img.shields.io/badge/Java-21-orange)]()
[![Angular](https://img.shields.io/badge/Angular-17-red)]()

A **Jenkins CI/CD demonstration project** showcasing automated build, test, and deployment pipelines for a microservices architecture. This project features multi-service orchestration with Spring Boot backend services, Angular frontend, and comprehensive Jenkins automation.

## 🎯 Project Overview

This project demonstrates enterprise-grade CI/CD practices using Jenkins to automate:
- **Automated Testing**: Unit tests, integration tests, and code coverage reporting
- **Multi-Service Builds**: Parallel pipeline execution for microservices
- **Docker Integration**: Containerized builds and deployments
- **Blue-Green Deployments**: Zero-downtime deployment strategy with rollback capability
- **Notifications**: Email and Slack integration for build status updates
- **Test Reporting**: JUnit XML and JaCoCo coverage reports with thresholds

### Architecture Components
- **4 Backend Microservices** (Java 21 + Spring Boot 3.2.0)
- **1 Frontend Application** (Angular 17)
- **MongoDB Databases** (per-service isolation)
- **Apache Kafka** (event streaming)
- **Jenkins CI/CD** (automated pipelines)
- **Docker** (containerization)  

## 🚀 Quick Start - Jenkins CI/CD

### Start Jenkins Server
```bash
cd deployment
./start-jenkins.sh
```

**Access Jenkins:** http://localhost:8090  
**Default Credentials:** `admin` / `admin123`

The Jenkins server comes pre-configured with:
- Jenkins Configuration as Code (JCasC)
- Automatically created pipeline jobs for all services
- Docker integration for containerized builds
- Pre-installed plugins (Git, Docker, Pipeline, JUnit, JaCoCo)

### Stop Jenkins
```bash
cd deployment
./stop-jenkins.sh
```

## 🏗️ Architecture & Services

### Microservices (Java 21 + Spring Boot 3.2.0)

| Service | Port | Description | Jenkinsfile |
|---------|------|-------------|------------|
| **User Service** | 8081 | Authentication, user management, JWT, avatar uploads | [user-service/Jenkinsfile](user-service/Jenkinsfile) |
| **Product Service** | 8082 | Product CRUD, seller authorization, MongoDB | [product-service/Jenkinsfile](product-service/Jenkinsfile) |
| **Media Service** | 8083 | Image uploads, file validation, storage | [media-service/Jenkinsfile](media-service/Jenkinsfile) |
| **API Gateway** | 8080 | Request routing, centralized API entry | [api-gateway/Jenkinsfile](api-gateway/Jenkinsfile) |

### Frontend Application

| Application | Port | Description | Jenkinsfile |
|-------------|------|-------------|------------|
| **Frontend** | 4200 | Angular 17, Karma/Jasmine tests | [frontend/Jenkinsfile](frontend/Jenkinsfile) |

### Full-Stack Pipeline
- **Full-Stack Deployment**: [deployment/Jenkinsfile.fullstack](deployment/Jenkinsfile.fullstack) - Orchestrates all services

### Technology Stack
- **CI/CD**: Jenkins, Docker, Docker Compose, JCasC (Configuration as Code)
- **Backend**: Java 21, Spring Boot 3.2.0, Maven, MongoDB, Kafka
- **Frontend**: Angular 17, Node.js, Karma, Jasmine
- **Testing**: JUnit 5, JaCoCo (50% coverage threshold), Maven Surefire/Failsafe
- **Security**: JWT, BCrypt, Role-based access control (RBAC)

## ✨ Jenkins Pipeline Features

### Automated Build & Test
- **Checkout**: Automatic Git repository cloning
- **Build**: Maven/npm compilation with dependency resolution
- **Unit Tests**: JUnit 5 for Java, Karma/Jasmine for Angular
- **Integration Tests**: Maven Failsafe plugin
- **Code Coverage**: JaCoCo with 50% threshold enforcement
- **Test Reports**: JUnit XML parsing and visualization in Jenkins UI

### Deployment Strategies
- **Blue-Green Deployment**: Zero-downtime deployments with instant rollback
- **Environment-Specific**: Parameterized builds for dev/staging/production
- **Docker Integration**: Containerized builds and deployments
- **Health Checks**: Automated service health verification post-deployment

### Quality Gates
- **Code Coverage Threshold**: Minimum 50% coverage required
- **Test Success**: All tests must pass before deployment
- **Build Verification**: Compilation errors block pipeline progression

### Notifications & Reporting
- **Email Notifications**: Build status updates with test reports
- **Slack Integration**: Real-time build notifications
- **Test Report Archives**: Historical test results accessible in Jenkins
- **Coverage Trends**: Track coverage improvements over time

### Pipeline Stages (Backend Services)
1. **Checkout** - Clone from Git repository
2. **Build** - Maven compile and package
3. **Test** - Execute unit tests with JaCoCo
4. **Coverage Check** - Enforce 50% threshold
5. **Deploy** - Docker container deployment
6. **Archive** - Store test reports and artifacts
7. **Notify** - Send status updates

### Pipeline Stages (Frontend)
1. **Checkout** - Clone from Git repository
2. **Install Dependencies** - npm install
3. **Build** - Angular production build
4. **Test** - Karma unit tests (headless Chrome)
5. **Coverage** - Istanbul coverage reporting
6. **Deploy** - Docker nginx deployment
7. **Archive** - Store test reports and build artifacts

## � Prerequisites

### Required Software
- **Docker Desktop** (24.0+) - For containerized Jenkins and services
- **Docker Compose** (2.0+) - Included with Docker Desktop
- **Git** - For repository access

### Optional (for local development)
- **Java 21** (OpenJDK or Eclipse Temurin)
- **Maven 3.9+**
- **Node.js 18+ LTS**
- **Angular CLI** (`npm install -g @angular/cli`)

### Verify Installation
```bash
docker --version          # Docker version 24.0+
docker-compose --version  # Docker Compose version 2.0+
git --version             # Git 2.x+
```

---

## 🚀 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/cmbigk/mr-jenk
cd mr-jenk
```

### 2. Start Jenkins CI/CD Server
```bash
cd deployment
./start-jenkins.sh
```

**What this does:**
- Starts Jenkins in Docker container (port 8090)
- Mounts Jenkins configuration and data volumes
- Installs required plugins automatically
- Sets up pre-configured pipeline jobs
- Initializes with admin credentials

**Access Jenkins:**  
Open http://localhost:8090 in your browser  
**Login:** `admin` / `admin123`

### 3. Explore Pre-Configured Pipelines

In Jenkins dashboard, you'll see pipeline jobs for:
- `user-service-pipeline`
- `product-service-pipeline`
- `media-service-pipeline`
- `api-gateway-pipeline`
- `frontend-pipeline`
- `fullstack-deployment`

### 4. Trigger Your First Build

**Option A: Manual Trigger (UI)**
1. Click on any pipeline job (e.g., `user-service-pipeline`)
2. Click **"Build Now"**
3. Watch the pipeline stages execute in real-time
4. View test reports and coverage after completion

**Option B: Automated Trigger (Git Push)**
1. Make a code change in any service
2. Commit and push to repository
3. Jenkins automatically detects changes and triggers build

### 5. View Build Results

After a build completes:
- **Console Output**: Full build logs
- **Test Results**: http://localhost:8090/job/user-service-pipeline/lastBuild/testReport/
- **Code Coverage**: http://localhost:8090/job/user-service-pipeline/lastBuild/jacoco/
- **Artifacts**: Downloadable build outputs

---

## 🔧 Jenkins Configuration

### Configuration as Code (JCasC)
Jenkins is configured using YAML files in [deployment/jenkins-config/jenkins.yaml](deployment/jenkins-config/jenkins.yaml):
- Security settings and credentials
- Plugin installations
- System configuration
- Initial admin user setup

### Pipeline Scripts
Each service has a `Jenkinsfile` defining its pipeline:
- [user-service/Jenkinsfile](user-service/Jenkinsfile)
- [product-service/Jenkinsfile](product-service/Jenkinsfile)
- [media-service/Jenkinsfile](media-service/Jenkinsfile)
- [api-gateway/Jenkinsfile](api-gateway/Jenkinsfile)
- [frontend/Jenkinsfile](frontend/Jenkinsfile)
- [deployment/Jenkinsfile.fullstack](deployment/Jenkinsfile.fullstack)

### Modifying Pipeline Configuration
1. Edit the `Jenkinsfile` in the service directory
2. Commit changes to repository
3. Jenkins automatically uses updated pipeline on next build

---

## 🏃 Running the Application Stack

While Jenkins automates deployments, you can also run services manually for development:

### Full Stack with Docker Compose
```bash
# Start all microservices + databases
docker-compose up --build -d

# Verify services are running
docker ps

# Check logs
docker-compose logs -f user-service

# Stop all services
docker-compose down
```

### Individual Service Development
```bash
# Backend service (user-service example)
cd user-service
mvn clean install
mvn spring-boot:run

# Frontend
cd frontend
npm install
ng serve
```

### Service Endpoints
| Service | URL |
|---------|-----|
| Jenkins | http://localhost:8090 |
| Frontend | http://localhost:4200 |
| User Service | http://localhost:8081 |
| Product Service | http://localhost:8082 |
| Media Service | http://localhost:8083 |
| API Gateway | http://localhost:8080 |

---

## 🧪 Testing & Quality Assurance

### Automated Testing in Jenkins

Every pipeline build automatically executes:
- **Unit Tests**: All service unit tests via Maven/npm
- **Integration Tests**: Maven Failsafe for integration scenarios
- **Code Coverage**: JaCoCo for Java, Istanbul for Angular
- **Quality Gates**: 50% minimum coverage threshold

### Viewing Test Reports in Jenkins

**After a build completes:**

1. **Test Results Summary**
   ```
   http://localhost:8090/job/user-service-pipeline/lastBuild/testReport/
   ```
   - Total tests executed
   - Pass/fail statistics
   - Failure details and stack traces
   - Trend graphs over time

2. **Code Coverage Report**
   ```
   http://localhost:8090/job/user-service-pipeline/lastBuild/jacoco/
   ```
   - Line coverage percentage
   - Branch coverage
   - Class and method coverage
   - Visual code highlighting

3. **Build Artifacts**
   ```
   http://localhost:8090/job/user-service-pipeline/lastBuild/artifact/
   ```
   - JAR files, WARs
   - Test reports (XML/HTML)
   - Coverage reports

### Running Tests Locally

**Backend Services:**
```bash
cd user-service

# Run unit tests
mvn test

# Run with coverage
mvn clean test jacoco:report

# View coverage report
open target/site/jacoco/index.html
```

**Frontend:**
```bash
cd frontend

# Run tests (interactive)
npm test

# Run tests (CI mode - headless)
npm run test:ci

# Run with coverage
npm run test:coverage

# View coverage report
open coverage/index.html
```

### Test Report Files

Jenkins archives these files after each build:
- `target/surefire-reports/*.xml` - JUnit XML test results
- `target/site/jacoco/` - Coverage HTML reports
- `target/jacoco.xml` - Coverage XML for parsing
- `coverage/` - Frontend coverage (Angular)

### Coverage Threshold Configuration

Configured in `pom.xml` (backend) and `karma.conf.js` (frontend):
```xml
<!-- pom.xml -->
<execution>
    <id>check</id>
    <goals>
        <goal>check</goal>
    </goals>
    <configuration>
        <rules>
            <rule>
                <limits>
                    <limit>
                        <minimum>0.50</minimum> <!-- 50% -->
                    </limit>
                </limits>
            </rule>
        </rules>
    </configuration>
</execution>
```

---

## 📊 Jenkins Pipeline Walkthrough

### Example: User Service Pipeline

1. **Trigger Build**
   - Go to http://localhost:8090/job/user-service-pipeline/
   - Click "Build Now"

2. **Watch Pipeline Stages**
   ```
   Stage View shows:
   ✓ Checkout (5s)
   ✓ Build (45s)
   ✓ Test (30s)
   ✓ Coverage Check (5s)
   ✓ Deploy (20s)
   ✓ Archive (10s)
   ```

3. **View Console Output**
   - Real-time log stream
   - Maven build output
   - Test execution details
   - Docker build/deploy logs

4. **Check Test Results**
   - Click "Test Result" link
   - View passed/failed tests
   - Drill down into failures

5. **Review Coverage**
   - Click "Coverage Report" link
   - See percentage by package
   - Identify untested code

### Full-Stack Deployment Pipeline

The `fullstack-deployment` pipeline orchestrates all services:

```bash
# Manually trigger (Jenkins UI)
http://localhost:8090/job/fullstack-deployment/

# Or trigger via curl
curl -X POST http://admin:admin123@localhost:8090/job/fullstack-deployment/build
```

**Pipeline Flow:**
1. **Parallel Builds**: All 4 backend services build simultaneously
2. **Frontend Build**: Angular production build
3. **Integration Tests**: Cross-service validation
4. **Blue-Green Deploy**: Deploy to blue environment
5. **Health Checks**: Verify all services are healthy
6. **Traffic Switch**: Route traffic to new deployment
7. **Rollback (if needed)**: Revert to green environment

---

## 🔄 CI/CD Workflow

### Development Workflow

```bash
# 1. Make code changes
vim user-service/src/main/java/com/ecommerce/UserService.java

# 2. Commit and push
git add .
git commit -m "Add new feature"
git push origin main

# 3. Jenkins auto-triggers build
# - Git webhook detects push
# - Pipeline starts automatically
# - Tests run, coverage checked
# - If passing, deploys to environment

# 4. Monitor build in Jenkins UI
# http://localhost:8090/job/user-service-pipeline/

# 5. Review results
# - Check test reports
# - Verify coverage maintained
# - Confirm deployment successful
```

### Deployment Environments

Pipelines support parameterized deployments:
- **dev**: Development environment (auto-deploy)
- **staging**: Staging environment (manual approval)
- **production**: Production environment (manual approval + rollback)

### Rollback Procedure

If deployment fails or issues detected:

1. **Automatic Rollback** (blue-green)
   - Health checks fail → auto-rollback
   - Jenkins reverts to previous deployment

2. **Manual Rollback** (Jenkins UI)
   - Go to pipeline job
   - Click "Rollback to Previous Version"
   - Confirm rollback

3. **Emergency Rollback** (Docker)
   ```bash
   # Stop current deployment
   docker-compose down
   
   # Revert to previous tag
   docker-compose pull <service-name>:previous
   docker-compose up -d
   ```

---

## 🐛 Troubleshooting

### Jenkins Issues

**Jenkins won't start:**
```bash
# Check if port 8090 is already in use
lsof -i :8090  # macOS/Linux
netstat -ano | findstr :8090  # Windows

# Stop existing Jenkins
cd deployment
./stop-jenkins.sh

# Remove Jenkins data and restart clean
docker-compose -f docker-compose.jenkins.yml down -v
./start-jenkins.sh
```

**Pipeline jobs not appearing:**
```bash
# Restart Jenkins container
cd deployment
docker-compose -f docker-compose.jenkins.yml restart

# Check Jenkins logs
docker logs jenkins-server
```

**Build fails with "cannot connect to Docker daemon":**
```bash
# Ensure Docker socket is mounted correctly
# Check deployment/docker-compose.jenkins.yml

# Verify Docker is running
docker ps

# Restart Docker Desktop
```

### Docker Issues

**Port conflicts:**
```bash
# Find process using port
lsof -i :8081  # macOS/Linux
netstat -ano | findstr :8081  # Windows

# Kill process or change port in application.properties
```

**Containers won't start:**
```bash
# Check logs
docker-compose logs <service-name>

# Remove all containers and start fresh
docker-compose down -v
docker-compose up --build -d
```

**Out of disk space:**
```bash
# Clean up Docker resources
docker system prune -a --volumes

# Remove unused images
docker image prune -a
```

### Build Issues

**Maven build fails - tests:**
```bash
# Skip tests temporarily
mvn clean install -DskipTests

# Run specific test
mvn test -Dtest=UserServiceTest

# Clean Maven cache
rm -rf ~/.m2/repository
```

**npm install fails:**
```bash
cd frontend

# Clear cache
npm cache clean --force

# Remove and reinstall
rm -rf node_modules package-lock.json
npm install
```

**Coverage threshold not met:**
```bash
# View current coverage
mvn jacoco:report
open target/site/jacoco/index.html

# Temporarily disable threshold (for debugging)
# Comment out jacoco check goal in pom.xml
```

### MongoDB Issues

**Connection refused:**
```bash
# Check MongoDB containers are running
docker ps | grep mongodb

# Restart MongoDB
docker-compose restart mongodb-user

# Check connection string in application.properties
# spring.data.mongodb.uri=mongodb://mongodb-user:27017/userdb
```

**Database reset:**
```bash
# Connect to MongoDB
docker exec -it mongodb-user mongosh

# Drop database
use userdb
db.dropDatabase()
```

### Jenkins Build Agent Issues

**Agent offline:**
```bash
# Check agent status in Jenkins UI
# Manage Jenkins → Nodes

# Restart Jenkins
cd deployment
./stop-jenkins.sh
./start-jenkins.sh
```

**Workspace cleanup:**
```bash
# Clean workspace via Jenkins UI
# Job → Workspace → Wipe Out Workspace

# Or manually clean
rm -rf deployment/jenkins-data/workspace/*
```

---

## 📚 Project Structure

```
mr-jenk/
├── api-gateway/              # API Gateway service
│   ├── Jenkinsfile          # Pipeline definition
│   ├── Dockerfile           # Container image
│   └── src/                 # Source code
├── user-service/            # User authentication service
│   ├── Jenkinsfile
│   ├── Dockerfile
│   └── src/
├── product-service/         # Product management service
│   ├── Jenkinsfile
│   ├── Dockerfile
│   └── src/
├── media-service/           # Media upload service
│   ├── Jenkinsfile
│   ├── Dockerfile
│   └── src/
├── frontend/                # Angular frontend
│   ├── Jenkinsfile
│   ├── Dockerfile
│   └── src/
├── deployment/              # Jenkins CI/CD setup
│   ├── start-jenkins.sh     # Start Jenkins server
│   ├── stop-jenkins.sh      # Stop Jenkins server
│   ├── docker-compose.jenkins.yml
│   ├── Dockerfile.jenkins   # Custom Jenkins image
│   ├── Jenkinsfile.fullstack # Full-stack pipeline
│   └── jenkins-config/      # JCasC configuration
│       └── jenkins.yaml     # Jenkins Configuration as Code
├── docker-compose.yml       # Application services compose
└── README.md               # This file
```

---

## 🎓 Learning Objectives

This project demonstrates:

### Jenkins CI/CD Concepts
- ✅ **Pipeline as Code**: Jenkinsfiles define build processes
- ✅ **Configuration as Code**: JCasC for reproducible Jenkins setup
- ✅ **Automated Testing**: Unit and integration tests in pipeline
- ✅ **Code Coverage**: Quality gates with threshold enforcement
- ✅ **Docker Integration**: Containerized builds and deployments
- ✅ **Multi-Stage Pipelines**: Checkout → Build → Test → Deploy
- ✅ **Parallel Execution**: Multiple services building simultaneously
- ✅ **Artifact Archiving**: Test reports and build outputs preserved

### Microservices Patterns
- ✅ **Service Independence**: Each service has own repository, pipeline, database
- ✅ **API Gateway**: Centralized routing and request handling
- ✅ **Database per Service**: Isolated data stores
- ✅ **Event-Driven**: Kafka for asynchronous communication

### DevOps Practices
- ✅ **Infrastructure as Code**: Docker Compose definitions
- ✅ **Automated Deployments**: Push-to-deploy workflow
- ✅ **Blue-Green Deployment**: Zero-downtime releases
- ✅ **Health Checks**: Automated service verification
- ✅ **Rollback Strategy**: Quick recovery from failures

---

## 🎯 Next Steps & Enhancements

### Completed ✅
- Jenkins CI/CD automation with declarative pipelines
- Comprehensive test reporting (JUnit XML + JaCoCo)
- Docker containerization for all services
- Blue-green deployment strategy
- Configuration as Code (JCasC)

### Potential Improvements 🚀
- **Kubernetes Deployment**: Migrate from Docker Compose to K8s
- **Helm Charts**: Package services for Kubernetes
- **Integration Tests**: Cross-service E2E testing
- **Performance Testing**: JMeter/Gatling integration
- **Security Scanning**: SonarQube, OWASP Dependency Check
- **Multi-Branch Pipelines**: Feature branch deployments
- **GitOps**: ArgoCD or Flux for declarative deployments
- **Monitoring**: Prometheus + Grafana dashboards
- **Logging**: ELK stack (Elasticsearch, Logstash, Kibana)
- **Service Mesh**: Istio for advanced traffic management

---

## 📖 Additional Resources

### Documentation
- [Jenkins Official Docs](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [JCasC Documentation](https://github.com/jenkinsci/configuration-as-code-plugin)
- [Docker Documentation](https://docs.docker.com/)
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Angular Documentation](https://angular.io/docs)

### Pipeline Examples
- Individual service pipelines: `*/Jenkinsfile`
- Full-stack orchestration: [deployment/Jenkinsfile.fullstack](deployment/Jenkinsfile.fullstack)
- Jenkins setup: [deployment/jenkins-config/jenkins.yaml](deployment/jenkins-config/jenkins.yaml)

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes and commit (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
6. Jenkins automatically builds and tests your PR

---

## 📝 License

This project is for educational and demonstration purposes.

---

## 🎉 Quick Command Reference

```bash
# Start Jenkins
cd deployment && ./start-jenkins.sh

# Stop Jenkins  
cd deployment && ./stop-jenkins.sh

# Start application stack
docker-compose up -d

# Stop application stack
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Run tests locally (backend)
cd [service] && mvn test

# Run tests locally (frontend)
cd frontend && npm test

# Clean Docker system
docker system prune -a --volumes

# Access Jenkins
open http://localhost:8090
```

---

**🚀 Ready to start? Run `cd deployment && ./start-jenkins.sh` and visit http://localhost:8090**
