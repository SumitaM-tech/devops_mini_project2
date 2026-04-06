# Jenkins Integration - Quick Start

## Files Added to Your Project

1. **Jenkinsfile** - Complete CI/CD pipeline
2. **JENKINS_SETUP.md** - Detailed setup instructions
3. **Updated .dockerignore** - Excludes Jenkins files from Docker
4. **Updated package.json** - Added test reporting for Jenkins

## 3-Minute Setup

### 1. Add Credentials to Jenkins

Open Jenkins → Manage Jenkins → Credentials → Global → Add Credentials

**Already have:**
- ✓ `dockerhub-credentials` (Username/Password)

**Need to add (3 more):**

```
1. Secret Text
   ID: render-api-key
   Secret: [Your Render API key]

2. Secret Text
   ID: render-service-id
   Secret: [Your Render service ID]

3. Secret Text
   ID: render-app-url
   Secret: [your-app.onrender.com]
```

### 2. Install NodeJS in Jenkins

Jenkins → Manage Jenkins → Tools → NodeJS installations
- Click "Add NodeJS"
- Name: `NodeJS 18`
- Version: NodeJS 18.x
- Save

### 3. Create Jenkins Job

1. New Item → Pipeline → Name: `devops-mini-project`
2. Pipeline section:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: [Your GitHub repo]
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
3. Save

### 4. Push to GitHub

```bash
git add .
git commit -m "Add Jenkins integration"
git push origin main
```

### 5. Build

Jenkins → Your Job → Build Now

## Pipeline Flow

```
Checkout → Install → Test → Build Docker → Push DockerHub → Deploy Render → Health Check
```

## What Each Stage Does

- **Checkout**: Gets your code
- **Install**: Runs `npm install`
- **Test**: Runs `npm test` with coverage
- **Build**: Creates Docker image
- **Push**: Sends to DockerHub (phoenixfromashes/devops-mini-project)
- **Deploy**: Triggers Render deployment
- **Health Check**: Verifies app is live

## Expected Build Time

- First build: 3-5 minutes
- Subsequent builds: 2-3 minutes

## Success Looks Like

All stages GREEN + final message:
```
Deployment successful! App is live at https://your-app.onrender.com
```

## Common Issues

**Docker permission denied:**
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**Credentials not found:**
- Double-check credential IDs match exactly
- IDs are case-sensitive

**Build fails at test stage:**
```bash
cd app
npm install
npm test
```

## Done!

Your project now has Jenkins CI/CD. Every push to main triggers the full pipeline.

For detailed troubleshooting, see `JENKINS_SETUP.md`
