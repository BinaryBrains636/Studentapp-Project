output "cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_security_group_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_eks_cluster.vpc_config[0].cluster_security_group_id
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.id
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.eks_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.eks_public_subnet[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.eks_private_subnet[*].id
}

output "kubeconfig_command" {
  description = "Command to update kubeconfig"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name} --region ${var.aws_region}"
}
