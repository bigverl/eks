# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2026-09-13

### Added
- `/health/db` endpoint on a branched-off `pokefinder` backend
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
- `pokefinder` ECR repository to hold deployment images
