module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "pokefinder-eks"
  kubernetes_version = "1.33"

  # eks auto mode
  compute_config = {
    enabled = true
    node_pools: ["general-purpose"]
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

  node_security_group_tags = {
    "karpenter.sh/discovery" = "pokefinder-eks"
  }



  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


module "aws_lb_controller_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name = "pokefinder-lbc"

  attach_aws_lb_controller_policy = true

  associations = {
    this = {
      cluster_name    = module.eks.cluster_name
      namespace       = "kube-system"
      service_account = "aws-load-balancer-controller"
    }
  }

  tags = {
    Environment = "dev"
  }
}