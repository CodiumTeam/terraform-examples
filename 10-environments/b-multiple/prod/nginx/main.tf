terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }

  backend "s3" {
    region         = "eu-west-1"
    bucket         = "terraform-codium-state-bucket"
    key            = "environments/nginx-prod/terraform.tfstate"
    dynamodb_table = "terraform-locking"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "terraform-codium-state-bucket"
    key    = "environments/vpc-prod/terraform.tfstate"
    region = "eu-west-1"
  }
}
module "nginx" {
  source = "../../modules/nginx"

  subnet_id = data.terraform_remote_state.vpc.outputs.subnets[0]
  vpc_id    = data.terraform_remote_state.vpc.outputs.vpc_id

  naming_prefix = var.project_name
  instances     = var.instances
}