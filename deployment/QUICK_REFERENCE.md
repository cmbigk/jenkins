# CI/CD Quick Reference

## 🚀 Instant Build Trigger Setup

### Configure GitHub Webhook (Do This Now!)

1. **Go to GitHub:**
   ```
   https://github.com/YOUR_USERNAME/jenkins/settings/hooks
   ```

2. **Add Webhook:**
   - URL: `http://YOUR_JENKINS_HOST:8090/github-webhook/`
   - Content type: `application/json`
   - Events: Just the push event ✓
   - Active: ✓

3. **Test:**
   ```bash
   echo "test" >> README.md
   git commit -am "test: webhook trigger"
   git push
   # Build should start within 5 seconds!
   ```

## 📊 View Test Results

**Jenkins Dashboard:**
```
http://YOUR_JENKINS_HOST:8090/job/fullstack/
```

**Test Reports:**
```
http://YOUR_JENKINS_HOST:8090/job/fullstack/lastBuild/testReport/
```

**Coverage Report:**
```
http://YOUR_JENKINS_HOST:8090/job/fullstack/lastBuild/Frontend_Code_Coverage/
```

## 🧪 Run Tests Locally

### Backend (JUnit)
```bash
cd user-service
mvn test
open target/surefire-reports/index.html
```

### Frontend (Jasmine/Karma)
```bash
cd frontend
npm install  # First time only
npm run test:ci
open coverage/lcov-report/index.html
```

## 🔄 Manual Rollback

If deployment fails, rollback manually:

**Option 1: Jenkins Parameter**
1. Go to Jenkins → Build with Parameters
2. Check `ROLLBACK = true`
3. Click Build

**Option 2: Command Line**
```bash
docker-compose -f docker-compose.yml down
docker-compose -f docker-compose.yml up -d
```

## 📝 Pipeline Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| ENVIRONMENT | dev | Deployment environment |
| SKIP_TESTS | false | Skip tests (not recommended) |
| ROLLBACK | false | Rollback to previous version |

## 🐛 Troubleshooting

### Webhook Not Working?
```bash
# Check webhook delivery in GitHub
# Should see 200 OK responses

# Check Jenkins logs
docker logs jenkins-ci -f | grep github
```

### Tests Failing?
```bash
# Backend
mvn test -Dtest=ExampleTest

# Frontend
npm test -- --include='**/example.spec.ts'
```

### Build Stuck?
```bash
# Check Jenkins container
docker ps | grep jenkins-ci

# Check logs
docker logs jenkins-ci --tail 100

# Restart if needed
docker restart jenkins-ci
```

## 📚 Full Documentation

- **Webhook Setup:** [WEBHOOK_SETUP.md](./WEBHOOK_SETUP.md)
- **Testing Guide:** [TESTING_GUIDE.md](./TESTING_GUIDE.md)
- **Implementation:** [IMPLEMENTATION_SUMMARY.md](./IMPLEMENTATION_SUMMARY.md)

## ✅ Success Checklist

- [ ] Webhook configured in GitHub
- [ ] Test push triggers build instantly
- [ ] Backend tests run and pass
- [ ] Frontend tests run and pass
- [ ] Test results visible in Jenkins
- [ ] Coverage reports published
- [ ] Notifications working
- [ ] Services deployed successfully

## 🎯 Current Build Status

Check latest build:
```bash
# View Jenkins dashboard
open http://YOUR_JENKINS_HOST:8090/

# Current build should be #18 or higher
# Look for "Started by GitHub push"
```

## 💡 Pro Tips

1. **Commit Often:** Small commits = easier debugging
2. **Watch First Build:** Verify everything works
3. **Check Test Reports:** Ensure tests actually run
4. **Monitor Coverage:** Aim for >80%
5. **Use Parameters:** SKIP_TESTS for emergencies only

## 🚨 Emergency Contacts

If something breaks:
1. Check Jenkins console output
2. Review test reports
3. Check Docker logs
4. Rollback if needed
5. Review documentation

---

**Ready to test?** Configure the webhook now and push a commit! 🎉
