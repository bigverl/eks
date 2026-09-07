variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "eks-vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "vpc availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_public_subnets" {
  description = "list of vpc's public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "vpc_private_subnets" {
  description = "list of vpc's private subnets"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}