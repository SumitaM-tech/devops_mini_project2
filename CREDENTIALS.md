# Jenkins Credentials - Manual Entry Guide

Copy these into Jenkins UI exactly as shown:

## 1. DockerHub Credentials (Already Created ✓)
```
Kind: Username with password
Scope: Global
ID: dockerhub-credentials
Username: phoenixfromashes
Password: [your-dockerhub-password]
Description: DockerHub credentials for pushing images
```

## 2. Render API Key
```
Kind: Secret text
Scope: Global
ID: render-api-key
Secret: [paste your Render API key]
Description: Render API key for deployments
```

**How to get:**
1. Go to https://dashboard.render.com
2. Account Settings → API Keys
3. Create new API key or copy existing
4. Paste into Secret field

## 3. Render Service ID
```
Kind: Secret text
Scope: Global
ID: render-service-id
Secret: [your-service-id]
Description: Render service ID
```

**How to get:**
1. Go to your Render dashboard
2. Open your service
3. URL looks like: render.com/services/srv-XXXXXXXXXXXXXXXXXX
4. Copy the `srv-XXXXXXXXXXXXXXXXXX` part
5. Paste into Secret field

## 4. Render App URL
```
Kind: Secret text
Scope: Global
ID: render-app-url
Secret: [your-app.onrender.com]
Description: Render app URL
```

**How to get:**
1. Go to your Render service
2. Look for your app URL
3. Copy ONLY the domain (without https://)
4. Example: `devops-mini-project.onrender.com`
5. Paste into Secret field

---

## Adding Credentials in Jenkins UI

1. Jenkins Dashboard → Manage Jenkins
2. Click "Credentials"
3. Click "System" → "Global credentials (unrestricted)"
4. Click "Add Credentials" (button on left)
5. Fill form with details above
6. Click "Create"
7. Repeat for all 4 credentials

---

## Verify Credentials

After adding all, you should see:
- ✓ dockerhub-credentials (phoenixfromashes/*****)
- ✓ render-api-key (Secret text)
- ✓ render-service-id (Secret text)
- ✓ render-app-url (Secret text)

All 4 credentials must exist before running the pipeline.

---

## Common Mistakes

❌ Using wrong credential ID
✓ IDs must match EXACTLY (case-sensitive)

❌ Including https:// in app URL
✓ Just the domain: your-app.onrender.com

❌ Wrong service ID format
✓ Must start with: srv-

❌ Expired API key
✓ Generate fresh key from Render dashboard
