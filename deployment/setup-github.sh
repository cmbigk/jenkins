#!/bin/bash

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                                                                ║"
echo "║     GitHub Setup & Jenkins Integration Helper Script          ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Step 1: Clean up target files (build artifacts)${NC}"
git restore api-gateway/target/ 2>/dev/null || true
git restore media-service/target/ 2>/dev/null || true
git restore product-service/target/ 2>/dev/null || true
git restore user-service/target/ 2>/dev/null || true
echo -e "${GREEN}✓ Cleaned up build artifacts${NC}"
echo ""

echo -e "${YELLOW}Step 2: Stage all CI/CD files${NC}"
git add deployment/
git add */Jenkinsfile
git add README.md
git add .gitignore
echo -e "${GREEN}✓ Staged all CI/CD files${NC}"
echo ""

echo -e "${YELLOW}Step 3: Commit changes${NC}"
git commit -m "Add complete Jenkins CI/CD pipeline

Features:
- Jenkinsfiles for all 5 microservices
- Automated testing (JUnit + Jasmine/Karma)
- Blue-green deployment with rollback
- Health checks and smoke tests
- Email and Slack notifications
- Comprehensive documentation
- GitHub integration ready
- Security best practices

Deployment scripts:
- start-jenkins.sh / stop-jenkins.sh
- deploy.sh (blue-green deployment)
- rollback.sh (automatic rollback)
- health-check.sh (service monitoring)
- smoke-tests.sh (post-deployment validation)

Documentation:
- deployment/README.md (complete setup guide)
- deployment/QUICKSTART.md (5-minute start)
- deployment/TESTING_GUIDE.md (audit checklist)
- deployment/TROUBLESHOOTING.md (common issues)
- deployment/GITHUB_INTEGRATION.md (GitHub setup)

This implementation covers all CI/CD assessment requirements."
echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}Step 4: Create GitHub Repository${NC}"
echo ""
echo "Please follow these steps:"
echo ""
echo "1. Go to: https://github.com/new"
echo "2. Repository name: jenkins"
echo "3. Description: E-commerce CI/CD with Jenkins Pipeline"
echo "4. Choose: Public or Private"
echo "5. ❌ Do NOT initialize with README"
echo "6. Click 'Create repository'"
echo ""
read -p "Press Enter when you've created the GitHub repository..."
echo ""

echo -e "${YELLOW}Step 5: Set GitHub remote${NC}"
echo ""
read -p "Enter your GitHub username: " GITHUB_USER
echo ""

REPO_URL="https://github.com/${GITHUB_USER}/jenkins.git"

# Check if remote exists
if git remote get-url origin &>/dev/null; then
    echo "Remote 'origin' already exists. Updating..."
    git remote set-url origin $REPO_URL
else
    echo "Adding remote 'origin'..."
    git remote add origin $REPO_URL
fi

echo -e "${GREEN}✓ GitHub remote configured: ${REPO_URL}${NC}"
echo ""

echo -e "${YELLOW}Step 6: Push to GitHub${NC}"
echo ""
echo "Running: git push -u origin main"
echo ""

if git push -u origin main; then
    echo ""
    echo -e "${GREEN}✓ Successfully pushed to GitHub!${NC}"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${GREEN}🎉 SUCCESS! Your code is now on GitHub!${NC}"
    echo ""
    echo "Repository URL: ${REPO_URL}"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${YELLOW}Next Steps:${NC}"
    echo ""
    echo "1. Open Jenkins: http://localhost:8090"
    echo ""
    echo "2. Follow the setup guide:"
    echo "   deployment/GITHUB_INTEGRATION.md"
    echo ""
    echo "3. Quick steps:"
    echo "   - Configure GitHub credentials in Jenkins"
    echo "   - Create pipelines for each service"
    echo "   - Test automatic build on push"
    echo ""
    echo "4. For detailed instructions:"
    echo "   cat deployment/GITHUB_INTEGRATION.md"
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
else
    echo ""
    echo -e "${RED}✗ Push failed!${NC}"
    echo ""
    echo "Common issues:"
    echo "1. Check your GitHub credentials"
    echo "2. Make sure you have access to the repository"
    echo "3. Try: git push origin main --force (if you're sure)"
    echo ""
    echo "Manual push:"
    echo "git push -u origin main"
fi
