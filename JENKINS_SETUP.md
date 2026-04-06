# Jenkins Integration Setup Guide

## Prerequisites Installed ✓
- Jenkins (running on localhost:8081)
- Docker plugin
- Git plugin
- NodeJS plugin
- Pipeline plugin
- Credentials Binding plugin

## Step 1: Configure Jenkins Credentials

### A. DockerHub Credentials (Already Created ✓)
1. Go to: `Manage Jenkins` → `Credentials` → `System` → `Global credentials`
2. Your credential ID: `dockerhub-credentials`
3. Username: `phoenixfromashes`
4. Password: (your DockerHub password)

### B. Add Render Credentials
Add these 3 credentials as "Secret text":

**1. Render API Key**
- Kind: Secret text
- ID: `render-api-key`
- Secret: (Your Render API key from https://dashboard.render.com/account/settings)

**2. Render Service ID**
- Kind: Secret text
- ID: `render-service-id`
- Secret: (Your Render service ID - found in service URL: render.com/services/srv-XXXXXX)

**3. Render App URL**
- Kind: Secret text
- ID: `render-app-url`
- Secret: (Your app URL without https://, e.g., your-app.onrender.com)

## Step 2: Configure Jenkins Tools

### A. NodeJS Configuration
1. `Manage Jenkins` → `Tools` → `NodeJS installations`
2. Click "Add NodeJS"
   - Name: `NodeJS 18`
   - Version: `NodeJS 18.x` (select latest)
   - Check "Install automatically"
   - Save

### B. Git Configuration (Auto-detected)
- Jenkins auto-detects Git from system PATH
- No manual config needed

## Step 3: Create Jenkins Pipeline Job

1. **New Item**
   - Name: `devops-mini-project-pipeline`
   - Type: `Pipeline`
   - Click OK

2. **Configure Pipeline**
   - Description: `DevOps Mini Project - CI/CD with Docker`
   
3. **Pipeline Definition**
   - Select: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: (Your GitHub repo URL)
   - Credentials: (Add GitHub credentials if private repo)
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

4. **Build Triggers** (Optional)
   - Check `GitHub hook trigger for GITScm polling` (if using webhooks)
   - OR `Poll SCM` with schedule: `H/5 * * * *` (polls every 5 mins)

5. **Save**

## Step 4: Project Files Added

### Files Created:
1. `Jenkinsfile` - Main pipeline configuration
2. `JENKINS_SETUP.md` - This guide
3. `.dockerignore` - Optimized Docker builds
4. Updated `package.json` - Added test reporting

### Files Modified:
- Added jest-junit reporter for test results

## Step 5: Run Your First Build

1. Go to your pipeline job
2. Click `Build Now`
3. Watch the console output

## Pipeline Stages:

1. **Checkout** - Pulls code from Git
2. **Install Dependencies** - Runs `npm install`
3. **Run Tests** - Runs `npm test`
4. **Build Docker Image** - Builds Docker image with tag
5. **Push to DockerHub** - Pushes to your DockerHub
6. **Deploy to Render** - Triggers Render deployment
7. **Health Check** - Verifies deployment

## Troubleshooting

### Docker Permission Denied
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### NodeJS Not Found
- Install NodeJS plugin
- Configure in Global Tool Configuration

### Git Not Found
```bash
# On Jenkins server
sudo apt-get update
sudo apt-get install git
```

### Docker Build Fails
- Ensure Docker daemon is running
- Check Jenkins user has Docker permissions

## Testing Locally Before Jenkins

```bash
# Test the app
cd app
npm install
npm test

# Build Docker image
docker build -t devops-mini-project:test .

# Run container
docker run -p 3000:3000 devops-mini-project:test

# Test endpoint
curl http://localhost:3000/health
```

## Webhook Setup (Optional - Auto-trigger builds)

### GitHub Webhook:
1. GitHub Repo → Settings → Webhooks → Add webhook
2. Payload URL: `http://your-jenkins-url:8081/github-webhook/`
3. Content type: `application/json`
4. Events: `Just the push event`
5. Active: ✓

## Next Steps

1. ✓ Add Jenkinsfile to your repo
2. ✓ Configure credentials in Jenkins
3. ✓ Create pipeline job
4. ✓ Run first build
5. Monitor builds and deployments

## Quick Command Reference

```bash
# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Restart Jenkins
sudo systemctl restart jenkins

# Check Docker
docker ps
docker images

# Clean Docker
docker system prune -a
```

## Success Indicators

- ✓ All pipeline stages turn GREEN
- ✓ Docker image pushed to DockerHub
- ✓ Render deployment triggered
- ✓ Health check returns 200
- ✓ App accessible at Render URL

---
**Your Jenkins is now integrated!** 🚀
