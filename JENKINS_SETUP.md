# Jenkins CI/CD Setup Guide

This guide explains how to set up Jenkins for automating the Student Application CI/CD pipeline.

## Overview

Jenkins will automate:
- Building the application with Maven
- Running unit tests
- Building Docker images
- Pushing images to Docker registry
- Deploying to EKS cluster
- Sending notifications

## Architecture

```
Git Repository → Jenkins → Docker Build → Docker Registry → EKS Deployment
```

## Prerequisites

Before setting up Jenkins, ensure you have:

1. **Docker and Docker Compose** installed
2. **AWS CLI** configured with credentials
3. **kubectl** configured for EKS access
4. **Docker Hub account** (or use ECR)
5. **EKS cluster** running (use Terraform in `eks-terraform/`)

## Step-by-Step Setup

### Step 1: Start Jenkins

```bash
cd jenkins
./setup-jenkins.sh
```

Or manually:

```bash
cd jenkins
docker-compose up -d
```

### Step 2: Access Jenkins

Navigate to: `http://localhost:8081`

### Step 3: Unlock Jenkins

Get the initial admin password:

```bash
docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
```

Paste this password in the Jenkins unlock screen.

### Step 4: Install Plugins

Select "Install suggested plugins" and wait for installation to complete.

### Step 5: Create Admin User

Create your first admin user with:
- Username
- Password
- Full name
- Email

### Step 6: Configure Jenkins URL

Accept the default URL or configure your own.

### Step 7: Configure Credentials

#### 7.1 Docker Registry Credentials

1. Go to `Manage Jenkins` > `Credentials` > `System` > `Global credentials`
2. Click `Add Credentials`
3. Select:
   - Kind: `Username with password`
   - Username: Your Docker Hub username
   - Password: Your Docker Hub password or access token
   - ID: `docker-registry-credentials`
4. Click `Create`

#### 7.2 AWS Credentials

1. Click `Add Credentials`
2. Select:
   - Kind: `AWS Credentials`
   - Access Key ID: Your AWS access key
   - Secret Access Key: Your AWS secret key
   - ID: `aws-credentials`
3. Click `Create`

#### 7.3 Kubeconfig

1. Click `Add Credentials`
2. Select:
   - Kind: `Secret file`
   - File: Upload your `~/.kube/config` file
   - ID: `kubeconfig`
3. Click `Create`

### Step 8: Configure Global Tools

1. Go to `Manage Jenkins` > `Global Tool Configuration`
2. Configure Maven:
   - Name: `Maven 3.9`
   - Version: `3.9.x`
   - Select "Install automatically"

### Step 9: Create Pipeline Job

1. Click `New Item`
2. Enter job name: `studentapp-pipeline`
3. Select `Pipeline`
4. Click `OK`
5. Under `Pipeline` section:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: Your GitHub repository URL
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`
6. Click `Save`

### Step 10: Configure GitHub Webhook (Optional)

For automatic builds on push:

1. Go to your GitHub repository
2. Navigate to `Settings` > `Webhooks`
3. Click `Add webhook`
4. Payload URL: `http://your-jenkins-server:8081/github-webhook/`
5. Content type: `application/json`
6. Select: `Just the push event`
7. Click `Add webhook`

### Step 11: Run the Pipeline

1. Click `Build Now` in the Jenkins job
2. Monitor the build progress
3. Check logs for any errors

## Pipeline Stages Explained

### 1. Checkout
Pulls the latest code from the Git repository.

### 2. Build Application
Compiles the application using Maven:
```bash
mvn clean package -DskipTests
```

### 3. Unit Tests
Runs unit tests:
```bash
mvn test
```

### 4. Build Docker Image
Builds the Docker image:
```bash
docker build -t studentapp:BUILD_NUMBER .
```

### 5. Tag Docker Image
Tags the image for versioning:
```bash
docker tag studentapp:BUILD_NUMBER studentapp:latest
```

### 6. Push Docker Image
Pushes to Docker registry (only on main/master branch):
```bash
docker push studentapp:BUILD_NUMBER
docker push studentapp:latest
```

### 7. Configure kubectl
Sets up kubectl for EKS access:
```bash
aws eks update-kubeconfig --name studentapp-eks-cluster --region us-west-2
```

### 8. Deploy to Kubernetes
Deploys to EKS (only on main/master branch):
```bash
kubectl apply -f k8s/
kubectl set image deployment/studentapp studentapp=studentapp:BUILD_NUMBER
```

### 9. Verify Deployment
Verifies the deployment:
```bash
kubectl get pods -n studentapp
kubectl get svc -n studentapp
```

## Customization

### Change Docker Registry

Edit `Jenkinsfile`:

```groovy
environment {
    DOCKER_REGISTRY = 'your-registry-url'
}
```

### Change EKS Cluster Name

Edit `Jenkinsfile`:

```groovy
environment {
    EKS_CLUSTER_NAME = 'your-cluster-name'
}
```

### Add Email Notifications

Configure email in Jenkins:
1. Go to `Manage Jenkins` > `Configure System`
2. Scroll to `E-mail Notification`
3. Configure SMTP server
4. Set admin email

### Add Slack Notifications

Install Slack Notification plugin and configure webhook.

## Troubleshooting

### Jenkins Container Won't Start

Check logs:
```bash
docker-compose logs jenkins
```

### Docker Build Fails

Ensure Docker-in-Docker is running:
```bash
docker ps | grep jenkins-docker
```

### kubectl Connection Failed

Verify kubeconfig:
```bash
docker exec jenkins-server kubectl get nodes
```

### AWS Credentials Error

Verify AWS credentials are correctly configured in Jenkins.

### Build Stuck on Kubernetes Deployment

Check:
- EKS cluster is running
- kubectl has proper permissions
- Network connectivity to EKS

## Production Best Practices

1. **Use Jenkins Agents**: Separate build agents for isolation
2. **Persistent Storage**: Use volumes for Jenkins data
3. **Backup Strategy**: Regular backups of Jenkins configuration
4. **Security**: Enable SSL, use secrets, limit access
5. **Monitoring**: Monitor Jenkins health and build metrics
6. **Resource Limits**: Set CPU and memory limits
7. **Service Accounts**: Use IAM roles for AWS access

## Maintenance

### Update Jenkins

```bash
cd jenkins
docker-compose down
docker-compose pull
docker-compose up -d
```

### Backup Jenkins Data

```bash
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar czf /backup/jenkins-backup.tar.gz /data
```

### Restore Jenkins Data

```bash
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar xzf /backup/jenkins-backup.tar.gz -C /
```

## Additional Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)
- [Kubernetes CLI Plugin](https://plugins.jenkins.io/kubernetes-cli/)
