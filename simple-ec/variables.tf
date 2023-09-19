variable "project_name" {
  type        = string
  description = "Project name. Used for tagging resources"
  default     = null
}

variable "public_key" {
  type        = string
  description = "Public SSH key to allow access to the EC2 instance"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "Size for the EC2 instance"
  type        = string
}
