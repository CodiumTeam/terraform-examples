output "subnets" {
  description = "IDs of the created subnets"
  value       = module.vpc.public_subnets
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}
