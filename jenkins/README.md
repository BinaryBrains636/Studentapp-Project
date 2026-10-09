# Jenkins CI/CD for Student Application

This directory contains Jenkins configuration for automating the build, test, and deployment of the Student Application to EKS.

## Prerequisites

- Docker installed
- Docker Compose installed
- AWS CLI configured with appropriate credentials
- kubectl configured for EKS access
- Docker registry account (Docker Hub or ECR)

## Quick Start

### 1. Start Jenkins

```bash
cd jenkins
docker-compose up -d
```

Or use the setup script:

```bash
./setup-jenkins.sh
```

### 2. Access Jenkins

Open your browser and navigate to: `http://localhost:8081`

### 3. Initial Setup

1. Unlock Jenkins using the initial admin password:
   ```bash
   docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
   ```

2. Install suggested plugins

3. Create first admin user

4. Configure Jenkins URL

### 4. Configure Credentials

Navigate to: `Manage Jenkins` > `Credentials` > `System` > `Global credentials`

#### Docker Registry Credentials
- **Kind**: Username with password
- **Username**: Your Docker Hub username
- **Password**: Your Docker Hub password or access token
- **ID**: `docker-registry-credentials`

#### AWS Credentials
- **Kind**: AWS Credentials
- **Access Key ID**: Your AWS access key
- **Secret Access Key**: Your AWS secret key
- **ID**: `aws-credentials`

#### Kubeconfig
- **Kind**: Secret file
- **File**: Your kubeconfig file
- **ID**: `kubeconfig`

### 5. Configure Global Tool Settings

Navigate to: `Manage Jenkins` > `Global Tool Configuration`

- **Maven**: Install Maven (version 3.9.x)
- **Docker**: Should be available via Docker-in-Docker
- **kubectl**: Pre-installed in Jenkins Docker image

### 6. Create Pipeline Job

1. Click "New Item"
2. Enter job name (e.g., `studentapp-pipeline`)
3. Select "Pipeline"
4. Click "OK"
5. Under "Pipeline" section:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - Repository URL: Your GitHub repository URL
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

### 7. Run the Pipeline

Click "Build Now" to trigger the pipeline.

## Pipeline Stages

The Jenkinsfile defines the following stages:

1. **Checkout**: Pulls the latest code from Git
2. **Build Application**: Builds the application with Maven
3. **Unit Tests**: Runs unit tests
4. **Build Docker Image**: Builds the Docker image
5. **Tag Docker Image**: Tags the image with build number
6. **Push Docker Image**: Pushes to Docker registry (main/master branch only)
7. **Configure kubectl**: Sets up kubectl for EKS access
8. **Deploy to Kubernetes**: Deploys to EKS (main/master branch only)
9. **Verify Deployment**: Verifies the deployment

## Manual Triggers

The pipeline can be triggered by:
- Git push to main/master branch
- Manual "Build Now" button
- Webhook from GitHub (requires webhook configuration)

## Environment Variables

The pipeline uses the following environment variables:

- `DOCKER_REGISTRY`: Docker registry URL (default: docker.io)
- `DOCKER_IMAGE`: Docker image name (default: studentapp)
- `DOCKER_TAG`: Image tag (build number)
- `AWS_REGION`: AWS region (default: us-west-2)
- `EKS_CLUSTER_NAME`: EKS cluster name (default: studentapp-eks-cluster)

## Notifications

The pipeline sends email notifications on:
- Success: Job completed successfully
- Failure: Job failed

Configure email in: `Manage Jenkins` > `Configure System` > `E-mail Notification`

## Customization

### Modify Pipeline Stages

Edit the `Jenkinsfile` in the repository root to add, remove, or modify pipeline stages.

### Change Docker Registry

Update the `DOCKER_REGISTRY` environment variable in the Jenkinsfile:

```groovy
environment {
    DOCKER_REGISTRY = 'your-registry-url'
}
```

### Change Kubernetes Namespace

Update the namespace in the deployment stage:

```groovy
sh "kubectl apply -f k8s/namespace.yaml"
```

### Add Parallel Stages

To run stages in parallel:

```groovy
stage('Parallel Tests') {
    parallel {
        stage('Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Integration Tests') {
            steps {
                sh 'mvn verify'
            }
        }
    }
}
```

## Troubleshooting

### Jenkins Won't Start

Check logs:
```bash
docker-compose logs jenkins
```

### Docker-in-Docker Issues

Ensure the docker:dind container is running:
```bash
docker ps | grep jenkins-docker
```

### kubectl Connection Issues

Verify kubeconfig is correctly configured:
```bash
docker exec jenkins-server kubectl get nodes
```

### Permission Issues

Jenkins container runs as root to access Docker. Ensure proper permissions are set.

### Build Failures

Check console output in Jenkins for detailed error messages.

### Plugin Installation Issues

Manually install required plugins:
- Docker Pipeline
- Kubernetes CLI
- AWS Credentials
- Email Extension

## Maintenance

### Backup Jenkins Data

Backup the Jenkins volume:
```bash
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar czf /backup/jenkins-backup.tar.gz /data
```

### Restore Jenkins Data

Restore from backup:
```bash
docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar xzf /backup/jenkins-backup.tar.gz -C /
```

### Update Jenkins

Stop containers, pull new image, and restart:
```bash
docker-compose down
docker-compose pull
docker-compose up -d
```

### Clean Up

Stop and remove Jenkins containers:
```bash
docker-compose down -v
```

## Security Best Practices

1. Change default admin password
2. Enable CSRF protection
3. Configure role-based access control
3. Use secrets for sensitive data
4. Limit plugin installations
5. Regular security updates
6. Enable audit logging
7. Use HTTPS in production

## Production Considerations

1. Use persistent storage for Jenkins data
2. Configure backup strategy
3. Use Jenkins agents for distributed builds
4. Enable build triggers (webhooks, polling)
5. Configure resource limits
6. Use service accounts for AWS and Docker
7. Implement proper logging and monitoring

## License

This configuration is part of the Student Application project.
