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
    key            = "environments/vpc-prod/terraform.tfstate"
    dynamodb_table = "terraform-locking"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  naming_prefix           = var.project_name
  availability_zone_count = var.availability_zone_count
}