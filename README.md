# eks

Amazon EKS cluster provisioned via Terraform, running `pokefinder` as the
deployed workload.

## Structure
- `terraform/cluster/` — VPC + EKS cluster + Managed Node Group
- `terraform/ecr/` — container image repository (separate, long-lived state)

## Stack
- Terraform, using community modules
- AWS EKS - Managed Node Group
- AWS ECR
