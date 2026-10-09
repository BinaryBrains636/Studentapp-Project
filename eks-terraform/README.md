# EKS Infrastructure for Student Application

This Terraform configuration provisions an AWS EKS cluster for the Student Application, including VPC, subnets, node groups, and security groups.

## Prerequisites

- Terraform installed (version >= 1.0)
- AWS CLI configured with appropriate credentials
- kubectl installed
- Docker installed (for building application image)

## Architecture

The infrastructure provisions:
- **VPC**: Custom VPC with public and private subnets
- **Internet Gateway**: For public subnet internet access
- **NAT Gateways**: For private subnet internet access
- **EKS Cluster**: Kubernetes cluster with specified version
- **Node Group**: Managed node group with auto-scaling
- **Security Groups**: For cluster and node communication

## Quick Start

### 1. Configure Variables

Copy the example variables file and update it with your values:

```bash
cd eks-terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your AWS configuration.

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan the Infrastructure

```bash
terraform plan -out=tfplan
```

### 4. Apply the Infrastructure

```bash
terraform apply tfplan
```

Or to apply without a saved plan:

```bash
terraform apply
```

### 5. Configure kubectl

After successful deployment, configure kubectl:

```bash
aws eks update-kubeconfig --name studentapp-eks-cluster --region us-west-2
```

Verify cluster connection:

```bash
kubectl get nodes
```

### 6. Build and Push Docker Image

Build the application Docker image:

```bash
cd ..
docker build -t studentapp:latest .
```

If using ECR, tag and push the image:

```bash
aws ecr create-repository --repository-name studentapp
docker tag studentapp:latest <aws-account-id>.dkr.ecr.us-west-2.amazonaws.com/studentapp:latest
docker push <aws-account-id>.dkr.ecr.us-west-2.amazonaws.com/studentapp:latest
```

Update the image in `k8s/studentapp-deployment.yaml` if using ECR.

### 7. Deploy Application to EKS

Apply Kubernetes manifests:

```bash
cd k8s
kubectl apply -f namespace.yaml
kubectl apply -f mysql-secret.yaml
kubectl apply -f mysql-configmap.yaml
kubectl apply -f mysql-init-configmap.yaml
kubectl apply -f mysql-deployment.yaml
kubectl apply -f studentapp-configmap.yaml
kubectl apply -f studentapp-deployment.yaml
```

Or apply all at once:

```bash
kubectl apply -f .
```

### 8. Verify Deployment

Check pods:

```bash
kubectl get pods -n studentapp
```

Check services:

```bash
kubectl get svc -n studentapp
```

Get the LoadBalancer URL:

```bash
kubectl get svc studentapp -n studentapp
```

Access the application at the LoadBalancer URL: `http://<loadbalancer-url>/studentapp/`

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-west-2` |
| `project_name` | Project name | `studentapp` |
| `environment` | Environment name | `dev` |
| `cluster_name` | EKS cluster name | `studentapp-eks-cluster` |
| `vpc_cidr` | CIDR block for VPC | `10.0.0.0/16` |
| `availability_zones` | List of availability zones | `["us-west-2a", "us-west-2b"]` |
| `kubernetes_version` | Kubernetes version | `1.29` |
| `node_instance_type` | EC2 instance type for nodes | `t3.medium` |
| `node_min_size` | Minimum number of nodes | `1` |
| `node_max_size` | Maximum number of nodes | `3` |
| `node_desired_size` | Desired number of nodes | `2` |
| `allowed_cidr_blocks` | CIDR blocks for cluster access | `["0.0.0.0/0"]` |

## Outputs

- `cluster_id`: EKS cluster ID
- `cluster_endpoint`: EKS cluster endpoint
- `cluster_arn`: EKS cluster ARN
- `cluster_security_group_id`: Security group ID
- `cluster_name`: EKS cluster name
- `node_group_id`: Node group ID
- `node_group_arn`: Node group ARN
- `vpc_id`: VPC ID
- `public_subnet_ids`: Public subnet IDs
- `private_subnet_ids`: Private subnet IDs
- `kubeconfig_command`: Command to update kubeconfig

## Kubernetes Resources

The Kubernetes manifests deploy:
- **Namespace**: `studentapp`
- **MySQL**: Deployment with ConfigMap and Secret
- **Student App**: Deployment with ConfigMap and Secret
- **Services**: ClusterIP for MySQL, LoadBalancer for Student App

## Scaling

To scale the application:

```bash
kubectl scale deployment studentapp --replicas=3 -n studentapp
```

To scale MySQL (not recommended in production):

```bash
kubectl scale deployment mysql --replicas=1 -n studentapp
```

## Monitoring

View logs:

```bash
kubectl logs -f deployment/studentapp -n studentapp
kubectl logs -f deployment/mysql -n studentapp
```

View pod status:

```bash
kubectl get pods -n studentapp -w
```

## Destroy Infrastructure

To destroy all created resources:

```bash
cd eks-terraform
terraform destroy
```

First, delete Kubernetes resources:

```bash
kubectl delete namespace studentapp
```

## Security Considerations

- Restrict `allowed_cidr_blocks` to your IP address for production
- Use AWS Secrets Manager for sensitive data instead of Kubernetes Secrets
- Enable EKS control plane logging
- Use IAM roles for service accounts (IRSA)
- Enable pod security policies
- Use network policies for pod-to-pod communication

## Cost Optimization

- Use `t3.medium` for development/testing
- Consider using Spot Instances for non-critical workloads
- Enable cluster autoscaler
- Use horizontal pod autoscaler (HPA)
- Remove unused resources

## Troubleshooting

### Cluster Not Accessible
- Check security group rules
- Verify subnet configuration
- Ensure kubectl is configured correctly

### Pods Not Starting
- Check logs: `kubectl logs <pod-name> -n studentapp`
- Verify image pull policy
- Check resource limits
- Ensure ConfigMaps and Secrets exist

### MySQL Connection Issues
- Verify MySQL pod is running: `kubectl get pods -n studentapp`
- Check MySQL logs: `kubectl logs deployment/mysql -n studentapp`
- Verify database initialization
- Check service connectivity

## License

This infrastructure code is part of the Student Application project.
