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

output "create_backend_configmap" {
  description = "Configure backend config map with DB info"
  sensitive = true
  value = join(" ", [
    "kubectl create configmap backend-config -n pokefinder",
    "--from-literal=DB_HOST=${module.db.db_instance_address}",
    "--from-literal=DB_PORT=${module.db.db_instance_port}",
    "--from-literal=DB_USER=${module.db.db_instance_username}",
    "--from-literal=DB_NAME=${module.db.db_instance_name}",
  ])
}

output "create_backend_secret" {
  description = "Configure backend secret with DB credentials"
  value = join(" ", [
    "kubectl create secret generic backend-secret -n pokefinder",
    "--from-literal=DB_PASSWORD=$(aws secretsmanager get-secret-value",
    "--secret-id ${module.db.db_instance_master_user_secret_arn}",
    "--query SecretString --output text | jq -r .password)",
  ])
}