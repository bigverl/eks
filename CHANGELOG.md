# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.0] - 2026-10-01

### Added
- Backend: Pod autoscaling via HorizontalPodAutoscaler (HPA) and node autoscaling via Karpenter
- Load tested with 3 busyboxes. Scaled up to 30 pods across 1 additional node. Scaled back down to default.

## [0.6.0] - 2026-09-30

### Added
- `pokefinder.net` custom domain routed at the ALB via Route 53, ACM wildcard cert for HTTPS (www and any other subdomain)
- Implemented ExternalDNS K8s component to keep DNS record persistent rather than randomly-generated hostnames each time.
- Deployed and confirmed through curl to `https://www.pokefinder.net/health/db`

## [0.5.0] - 2026-09-17

### Added
- Helm chart at `charts/pokefinder/` replacing `manifests/pokefinder/`
- Image tags, replicas, resources, and DB host parameterized via `values.yaml`
- Deployed and confirmed through curl to `/health/db`

## [0.4.0] - 2026-09-16

### Added
- RDS Postgres via Terraform (`terraform/cluster/rds.tf`). AWS-managed master password
- RDS info injected into backend via configmap and secret in backend/deployment.yaml
- Confirmed `/health/db` returns healthy through the ALB

## [0.3.0] - 2026-09-13

### Added
- `/health/db` endpoint on a branched-off pokefinder backend
- `manifests/pokefinder/` — Namespace, backend/frontend Deployments
- Deployed Pokefinder cluster and verified reachable end-to-end through ALB

## [0.2.0] - 2026-09-11

### Added
- AWS Load Balancer Controller installed via Helm
- EKS Pod Identity for the controller's AWS permissions
- `manifests/hello-example/` — throwaway deployment proving the controller provisions a real ALB and routes traffic to pods

## [0.1.0] - 2026-09-07

### Added
- Basic infra: VPC, 2 public, 2 private subnets across 2 AZs, single NAT gateway
- EKS cluster with public endpoint access
- EKS Managed Node Group
- pokefinder ECR repository to hold deployment images
