# Terraform Infrastructure for Student Application

This Terraform configuration provisions AWS infrastructure for the Student Application, including an EC2 instance with Docker and security groups.

## Prerequisites

- Terraform installed (version >= 1.0)
- AWS CLI configured with appropriate credentials
- An existing VPC and subnet in your AWS account
- An SSH key pair for EC2 access

## Architecture

The infrastructure provisions:
- **EC2 Instance**: Ubuntu 22.04 with Docker and Docker Compose pre-installed
- **Security Group**: Allows SSH (22), HTTP (8080), and MySQL (3306) access
- **Key Pair**: For SSH access to the EC2 instance

## Quick Start

### 1. Configure Variables

Copy the example variables file and update it with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your AWS configuration:

```hcl
aws_region  = "us-west-2"
vpc_id      = "vpc-xxxxxxxxxxxxx"
subnet_id   = "subnet-xxxxxxxxxxxxx"
public_key_path   = "~/Downloads/studentapp.pem"
```

### 2. Initialize Terraform

```bash
cd terraform
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

### 5. Get Outputs

After successful deployment, get the connection details:

```bash
terraform output
```

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-west-2` |
| `project_name` | Project name | `studentapp` |
| `environment` | Environment name | `dev` |
| `vpc_id` | VPC ID (required) | - |
| `subnet_id` | Subnet ID (required) | - |
| `instance_type` | EC2 instance type | `t3.micro` |
| `public_key_path` | Path to SSH public key (required) | - |
| `allowed_ssh_cidr` | CIDR for SSH access | `["0.0.0.0/0"]` |
| `allowed_http_cidr` | CIDR for HTTP access | `["0.0.0.0/0"]` |
| `allowed_mysql_cidr` | CIDR for MySQL access | `["0.0.0.0/0"]` |

## Outputs

- `instance_id`: EC2 instance ID
- `instance_public_ip`: Public IP address
- `instance_public_dns`: Public DNS name
- `security_group_id`: Security group ID
- `key_pair_name`: AWS key pair name
- `ssh_connection_string`: SSH command to connect
- `application_url`: URL to access the application

## Deploying the Application

After Terraform creates the infrastructure:

1. **Connect to the instance**:
   ```bash
   ssh -i ~/Downloads/studentapp.pem ubuntu@<instance-public-dns>
   ```

2. **Copy application files**:
   ```bash
   scp -i ~/Downloads/studentapp.pem -r \
     Dockerfile docker-compose.yml .dockerignore source-code/ \
     ubuntu@<instance-public-dns>:~/studentapp/
   ```

3. **Build and run the application**:
   ```bash
   ssh -i ~/Downloads/studentapp.pem ubuntu@<instance-public-dns>
   cd ~/studentapp
   docker compose up -d
   ```

4. **Access the application**:
   ```
   http://<instance-public-dns>:8080/studentapp/
   ```

## Destroy Infrastructure

To destroy all created resources:

```bash
terraform destroy
```

## Security Considerations

- Restrict `allowed_ssh_cidr` to your IP address for production
- Restrict `allowed_http_cidr` to specific CIDR blocks if needed
- Consider using AWS Secrets Manager for sensitive data
- Enable VPC flow logs for monitoring

## Cost Optimization

- Use `t3.micro` for development/testing
- Consider using Spot Instances for non-critical workloads
- Enable auto-scaling groups for production
- Use S3 for storing application artifacts instead of EC2 local storage

## Troubleshooting

### Instance Not Accessible
- Check security group rules
- Verify subnet is public with internet gateway
- Ensure key pair is correctly configured

### Docker Installation Failed
- Check user_data script in EC2 console
- Verify instance has internet access
- Manual install: `sudo apt-get install -y docker.io docker-compose`

### Application Not Starting
- Check logs: `docker compose logs`
- Verify port 8080 is open in security group
- Ensure MySQL container is healthy: `docker compose ps`

## License

This infrastructure code is part of the Student Application project.
