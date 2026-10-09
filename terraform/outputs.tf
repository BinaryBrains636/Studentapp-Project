output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.studentapp_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.studentapp_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.studentapp_server.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.studentapp_sg.id
}

output "key_pair_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.studentapp_key.key_name
}

output "ssh_connection_string" {
  description = "SSH connection string to access the instance"
  value       = "ssh -i ${var.private_key_path} ubuntu@${aws_instance.studentapp_server.public_dns}"
}

output "application_url" {
  description = "URL to access the student application"
  value       = "http://${aws_instance.studentapp_server.public_dns}:8080/studentapp/"
}
