# Data source for AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for EC2
resource "aws_security_group" "studentapp_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for Student Application"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  # HTTP access for application
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr
  }

  # MySQL access (optional - for direct DB access)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.allowed_mysql_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# Key pair for EC2 access
resource "aws_key_pair" "studentapp_key" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)

  tags = {
    Name = "${var.project_name}-key"
  }
}

# EC2 Instance
resource "aws_instance" "studentapp_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.studentapp_key.key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.studentapp_sg.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              # Update system
              apt-get update -y

              # Install Docker
              apt-get install -y docker.io docker-compose

              # Add ubuntu user to docker group
              usermod -aG docker ubuntu

              # Start and enable Docker
              systemctl start docker
              systemctl enable docker

              # Create application directory
              mkdir -p /home/ubuntu/studentapp

              EOF

  tags = {
    Name        = "${var.project_name}-server"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_security_group.studentapp_sg, aws_key_pair.studentapp_key]
}
