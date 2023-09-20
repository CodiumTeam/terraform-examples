resource "aws_security_group" "this" {
  name   = "${var.naming_prefix}_sg"
  vpc_id = var.vpc_id

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
  for_each = var.instances

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = each.value.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  user_data                   = <<-EOT
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y nginx
      sudo ufw allow 'Nginx HTTTP'
    EOT
  vpc_security_group_ids      = [aws_security_group.this.id]

  tags = {
    Name = "${var.naming_prefix}_${each.key}_nginx"
  }
}
