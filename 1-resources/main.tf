terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

resource "aws_instance" "this" {
  ami           = "ami-01dd271720c1ba44f"
  instance_type = "t2.nano"

  tags = {
    Name = "ubuntu-ec2-machine"
  }
}