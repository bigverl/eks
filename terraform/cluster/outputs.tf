# vpc
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

# eks
output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster API server endpoint"
  value       = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Command to update kubeconfig for this cluster"
  value = join(" ", [
    "aws eks update-kubeconfig",
    "--region ${var.aws_region}",
    "--name ${module.eks.cluster_name}",
  ])
}

output "db_host" { 
  description = "RDS host without port"
  value = module.db.db_instance_address
}

output "create_backend_secret" {
  description = "Configure backend secret with DB credentials"
  value = join(" ", [
    "kubectl create secret generic pokefinder-backend-secret -n pokefinder",
    "--from-literal=DB_PASSWORD=$(aws secretsmanager get-secret-value",
    "--secret-id ${module.db.db_instance_master_user_secret_arn}",
    "--query SecretString --output text | jq -r .password)",
  ])
}