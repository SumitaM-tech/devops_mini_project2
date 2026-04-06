#!/bin/bash

# Jenkins Credentials Setup Helper
# Run this on your Jenkins server to verify setup

echo "================================"
echo "Jenkins Integration Checklist"
echo "================================"
echo ""

# Check Docker
echo "[1/5] Checking Docker..."
if command -v docker &> /dev/null; then
    echo "✓ Docker is installed"
    docker --version
else
    echo "✗ Docker not found. Install Docker first."
fi
echo ""

# Check Git
echo "[2/5] Checking Git..."
if command -v git &> /dev/null; then
    echo "✓ Git is installed"
    git --version
else
    echo "✗ Git not found. Install Git first."
fi
echo ""

# Check Jenkins
echo "[3/5] Checking Jenkins..."
if systemctl is-active --quiet jenkins; then
    echo "✓ Jenkins is running"
elif command -v jenkins &> /dev/null; then
    echo "⚠ Jenkins is installed but not running"
    echo "  Start with: sudo systemctl start jenkins"
else
    echo "✗ Jenkins not found"
fi
echo ""

# Check Node
echo "[4/5] Checking Node.js..."
if command -v node &> /dev/null; then
    echo "✓ Node.js is installed"
    node --version
else
    echo "✗ Node.js not found (Jenkins will install via plugin)"
fi
echo ""

# Jenkins user in Docker group
echo "[5/5] Checking Jenkins Docker permissions..."
if groups jenkins 2>/dev/null | grep -q docker; then
    echo "✓ Jenkins user in Docker group"
else
    echo "⚠ Jenkins user NOT in Docker group"
    echo "  Fix with: sudo usermod -aG docker jenkins"
    echo "  Then: sudo systemctl restart jenkins"
fi
echo ""

echo "================================"
echo "Next Steps:"
echo "================================"
echo "1. Open Jenkins: http://localhost:8081"
echo "2. Add these credentials (Manage Jenkins → Credentials):"
echo "   - render-api-key (Secret text)"
echo "   - render-service-id (Secret text)"
echo "   - render-app-url (Secret text)"
echo ""
echo "3. Configure NodeJS (Manage Jenkins → Tools)"
echo "   - Add NodeJS 18"
echo ""
echo "4. Create Pipeline Job"
echo "   - Pipeline from SCM"
echo "   - Git repository"
echo "   - Script path: Jenkinsfile"
echo ""
echo "5. Run Build Now"
echo ""

# Test if on Jenkins server
if [ -f "/var/lib/jenkins/config.xml" ]; then
    echo "✓ Running on Jenkins server"
    echo ""
    echo "Jenkins Home: /var/lib/jenkins"
    echo "Jenkins Logs: /var/log/jenkins/jenkins.log"
else
    echo "ℹ Not running on Jenkins server"
fi

echo "================================"
