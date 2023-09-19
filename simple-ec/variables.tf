variable "project_name" {
  type        = string
  description = "Project name. Used for tagging resources"
  default     = null
}

variable "public_key" {
  type        = string
  description = "Public SSH key to allow access to the EC2 instance"
}

variable "ubuntu_instances" {
  type = map(object({
    instance_type = optional(string, "t3.micro")
  }))
}
