data "aws_availability_zones" "available" {}

locals {
  tag_prefix = coalesce(var.project_name, basename(abspath(path.root)))
  vpc_cidr   = "10.0.0.0/16"
  azs        = slice(data.aws_availability_zones.available.names, 0, 1)
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.this.private_key_openssh
  filename = pathexpand("~/.ssh/id_ed25519")
}

resource "local_file" "private_key" {
  content  = tls_private_key.this.public_key_openssh
  filename = pathexpand("~/.ssh/id_ed25519.pub")
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.tag_prefix
  cidr = local.vpc_cidr

  azs            = local.azs
  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  tags = {
    Name = "${local.tag_prefix}_vpc"
  }
}

resource "aws_security_group" "this" {
  name   = "${local.tag_prefix}_sg"
  vpc_id = module.vpc.vpc_id

  // To Allow SSH Transport
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_key_pair" "this" {
  key_name   = local.tag_prefix
  public_key = tls_private_key.this.public_key_openssh
}


module "ubuntu_ec2" {
  source   = "./modules/ubuntu"
  for_each = var.ubuntu_instances

  instance = {
    key_name          = aws_key_pair.this.id
    subnet_id         = module.vpc.public_subnets[0]
    type              = each.value.instance_type
    security_group_id = aws_security_group.this.id
    profile           = each.value.profile

    tags = {
      Name = "${local.tag_prefix}_${each.key}"
    }
  }
}
