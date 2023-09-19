variable "project_name" {
  type        = string
  description = "Project name. Used for tagging resources"
  default     = null
}

variable "instance_type" {
  default     = "t3.micro"
  description = "Size for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "ID for VPC to attach EC2 instance"
  type        = string
}