data "aws_availability_zones" "available" {}

locals {
  tag_prefix = coalesce(var.project_name, basename(abspath(path.root)))
  vpc_cidr   = "10.0.0.0/16"
  azs        = slice(data.aws_availability_zones.available.names, 0, 1)
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
  public_key = var.public_key
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.id

  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  tags = {
    Name = "${local.tag_prefix}_ubuntu"
  }
}

check "ec2_instance_created" {
  data "aws_instance" "this" {
    instance_id = aws_instance.this.id
  }
  assert {
    condition     = data.aws_instance.this.instance_state == "running"
    error_message = "Instance is not running - it is ${data.aws_instance.this.instance_state}"
  }
}