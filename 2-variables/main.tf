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
  instance_type = var.instance_type

  tags = {
    Name = "${var.project_name}_ubuntu"
  }
}