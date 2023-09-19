variable "project_name" {
  type        = string
  description = "Project name. Used for tagging resources"
  default     = null
}

variable "ubuntu_instances" {
  type = map(object({
    instance_type = optional(string, "t3.micro")
  }))
}
