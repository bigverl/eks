data "aws_route53_zone" "this" {
  name = "pokefinder.net"
}

module "externaldns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.0"

  name = "pokefinder-externaldns"

  additional_policy_arns = {
    route53 = aws_iam_policy.externaldns.arn
  }

  associations = {
    this = {
      cluster_name    = module.eks.cluster_name
      namespace       = "kube-system"
      service_account = "external-dns"
    }
  }
}

resource "aws_iam_policy" "externaldns" {
  name = "pokefinder-externaldns"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["route53:ChangeResourceRecordSets"]
        Resource = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.this.zone_id}"
      },
      {
        Effect   = "Allow"
        Action   = ["route53:ListHostedZones", "route53:ListResourceRecordSets"]
        Resource = "*"
      }
    ]
  })
}
