variable "vpc_id" {
  description = "ID of the VPC to use for the EC2 instances"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to use for the EC2 instances and the security group"
  type        = string
}

variable "naming_prefix" {
  description = "Prefix to name resources"
  type        = string
}

variable "instances" {
  description = "EC2 nginx instances to create. The key is used to named the instance"
  type = map(object({
    instance_type = optional(string, "t2.nano")
  }))
}