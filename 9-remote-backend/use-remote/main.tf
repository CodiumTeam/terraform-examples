locals {
  naming_prefix = basename(abspath(path.root))
}

terraform {
// variables not allowed in this block
  backend "s3" {
    region         = "eu-west-1"
    bucket         = "terraform-codium-state-bucket"
    key            = "use-remote/terraform.tfstate"
    dynamodb_table = "terraform-locking"
  }
}

resource "aws_instance" "this" {
  ami           = "ami-01dd271720c1ba44f"
  instance_type = "t2.nano"

  tags = {
    Name = "ubuntu-ec2-machine"
  }
}