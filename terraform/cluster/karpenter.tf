module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 21.0"

  cluster_name = module.eks.cluster_name

  create_pod_identity_association = true
  create_instance_profile         = true
  enable_inline_policy            = true

  tags = {
    Environment = "dev"
  }
}
