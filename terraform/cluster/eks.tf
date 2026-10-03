module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "pokefinder-eks"
  kubernetes_version = "1.33"

  # eks auto mode
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  addons = {
    metrics-server = {}
  }

  # optional
  endpoint_public_access = true

  # optional: adds the caller identity as admin via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
