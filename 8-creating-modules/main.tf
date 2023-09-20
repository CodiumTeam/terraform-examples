terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

locals {
  naming_prefix = coalesce(var.project_name, basename(abspath(path.root)))
  vpc_cidr      = "10.0.0.0/16"
  azs           = slice(data.aws_availability_zones.available.names, 0, 1)
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.naming_prefix
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  tags = {
    Name = "${local.naming_prefix}_vpc"
  }
}

module "nginx" {
  source = "./modules/nginx"

  subnet_id     = module.vpc.public_subnets[0]
  vpc_id        = module.vpc.vpc_id
  naming_prefix = local.naming_prefix
  instances = {
    main   = {}
    backup = { instance_type = "t1.micro" }
  }
}