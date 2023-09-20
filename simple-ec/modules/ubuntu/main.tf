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
  instance_type               = var.instance.type
  subnet_id                   = var.instance.subnet_id
  associate_public_ip_address = true
  key_name                    = var.instance.key_name

  user_data                   = var.instance.user_data
  user_data_replace_on_change = true

  vpc_security_group_ids = [
    var.instance.security_group_id
  ]

  tags = var.instance.tags
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