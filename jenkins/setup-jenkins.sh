#!/bin/bash

echo "Setting up Jenkins server..."

# Start Jenkins
cd "$(dirname "$0")"
docker-compose up -d

echo "Waiting for Jenkins to start..."
sleep 60

# Get initial admin password
echo "Fetching initial admin password..."
docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword

echo ""
echo "Jenkins is starting at http://localhost:8081"
echo "Use the password above to unlock Jenkins"
echo ""
echo "After initial setup, configure the following:"
echo "1. Install required plugins (docker, kubernetes, aws-credentials)"
echo "2. Configure Docker registry credentials"
echo "3. Configure AWS credentials"
echo "4. Configure kubeconfig for EKS access"
echo "5. Create Pipeline job pointing to your repository"
