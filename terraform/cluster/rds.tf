module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "pokefinder-rds-sg"
  description = "pokefinder rds sg"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    https = {
      from_port                    = 5432
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.eks.node_security_group_id
    }
    self-all = {
      ip_protocol                  = "-1"
      referenced_security_group_id = "self"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}

module "db" {
  source = "terraform-aws-modules/rds/aws"
  identifier = "pokefinder-rds"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 10
  db_name  = "pokefinder"
  username = "pokefinder_admin"
  port     = "5432"

  manage_master_user_password = true
  vpc_security_group_ids      = [module.security_group.id]
  create_db_subnet_group      = true
  subnet_ids                  = module.vpc.private_subnets
  create_db_parameter_group   = false
  skip_final_snapshot         = true
}