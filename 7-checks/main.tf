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

resource "aws_security_group" "this" {
  name   = "${local.naming_prefix}_sg"
  vpc_id = module.vpc.vpc_id

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
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = <<-EOT
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y nginx
      sudo ufw allow 'Nginx HTTTP'
    EOT
  vpc_security_group_ids      = [aws_security_group.this.id]

  tags = {
    Name = "${local.naming_prefix}_ubuntu"
  }
}

check "health_check" {
  data "http" "this" {
    url = "http://${aws_instance.this.public_ip}"
  }

  assert {
    condition     = data.http.this.status_code == 200
    error_message = "${data.http.this.url} returned an unhealthy status code (${data.http.this.status_code})"
  }
}