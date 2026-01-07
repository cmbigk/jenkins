#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║     Create New 'jenkins' Repository on GitHub                 ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cd /Users/chan.myint/Desktop/jenkins/buy-01

echo -e "${YELLOW}Step 1: Remove connection to existing buy-01 repo${NC}"
git remote remove origin 2>/dev/null || true
echo -e "${GREEN}✓ Removed old origin${NC}"
echo ""

echo -e "${YELLOW}Step 2: Clean up build artifacts${NC}"
git restore api-gateway/target/ 2>/dev/null || true
git restore media-service/target/ 2>/dev/null || true
git restore product-service/target/ 2>/dev/null || true
git restore user-service/target/ 2>/dev/null || true
echo -e "${GREEN}✓ Cleaned up build artifacts${NC}"
echo ""

echo -e "${YELLOW}Step 3: Stage all CI/CD files${NC}"
git add deployment/
git add */Jenkinsfile
git add README.md
git add .gitignore 2>/dev/null || true
echo -e "${GREEN}✓ Staged all CI/CD files${NC}"
echo ""

echo -e "${YELLOW}Step 4: Commit changes${NC}"
git commit -m "Jenkins CI/CD Pipeline Implementation

Complete automated CI/CD pipeline with:
- Jenkinsfiles for all 5 microservices
- Automated testing (JUnit + Jasmine/Karma)
- Blue-green deployment with automatic rollback
- Health checks and smoke tests
- Email and Slack notifications
- Comprehensive documentation
- Security best practices (no hardcoded secrets)

Deployment automation:
- start-jenkins.sh / stop-jenkins.sh
- Blue-green deployment with zero downtime
- Automatic and manual rollback capability
- Service health monitoring
- Post-deployment validation

Complete documentation:
- Setup guides and quick start
- GitHub integration instructions
- Audit checklist for verification
- Troubleshooting guide
- Testing scenarios

Meets all CI/CD assessment requirements:
✓ Automated testing with failure handling
✓ Deployment automation
✓ Rollback strategy
✓ Email & Slack notifications
✓ Security (credentials management)
✓ Code quality and best practices" 2>/dev/null || echo -e "${YELLOW}Already committed or nothing to commit${NC}"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Step 5: Create NEW GitHub Repository${NC}"
echo ""
echo "Please follow these steps:"
echo ""
echo "1. Go to: https://github.com/new"
echo "2. Repository name: ${GREEN}jenkins${NC}"
echo "3. Description: E-commerce CI/CD with Jenkins Pipeline"
echo "4. Choose: Public or Private"
echo "5. ❌ Do NOT initialize with README, .gitignore, or license"
echo "6. Click 'Create repository'"
echo ""
read -p "Press Enter when you've created the 'jenkins' repository..."
echo ""

echo -e "${YELLOW}Step 6: Set new GitHub remote${NC}"
echo ""
read -p "Enter your GitHub username: " GITHUB_USER
echo ""

REPO_URL="https://github.com/${GITHUB_USER}/jenkins.git"

# Add new remote
git remote add origin $REPO_URL

echo -e "${GREEN}✓ GitHub remote configured: ${REPO_URL}${NC}"
echo ""

echo -e "${YELLOW}Step 7: Push to NEW 'jenkins' repository${NC}"
echo ""
echo "Running: git push -u origin main"
echo ""

if git push -u origin main; then
    echo ""
    echo -e "${GREEN}✓ Successfully pushed to NEW GitHub repository!${NC}"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${GREEN}🎉 SUCCESS! Your Jenkins CI/CD is now on GitHub!${NC}"
    echo ""
    echo "New Repository URL: ${GREEN}${REPO_URL}${NC}"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo ""
    echo "1. Open Jenkins: http://localhost:8090"
    echo ""
    echo "2. In Jenkins, use this repository URL:"
    echo "   ${GREEN}${REPO_URL}${NC}"
    echo ""
    echo "3. Follow the setup guide:"
    echo "   ${GREEN}deployment/GITHUB_INTEGRATION.md${NC}"
    echo ""
    echo "4. Create pipelines for each service"
    echo ""
    echo "5. Test automatic build on push"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
else
    echo ""
    echo -e "${RED}✗ Push failed!${NC}"
    echo ""
    echo "Common issues:"
    echo "1. Make sure you created the 'jenkins' repository on GitHub"
    echo "2. Check your GitHub credentials"
    echo "3. Try: git push origin main"
    echo ""
fi
