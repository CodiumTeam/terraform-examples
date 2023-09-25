variable "project_name" {
  description = "Name of the project. Used as prefix to name resources"
  type        = string
  default     = null
  validation {
    condition     = var.project_name != null ? length(var.project_name) <= 10 : true
    error_message = "The project_name needs no more than 10 chars long"
  }
  validation {
    condition     = var.project_name != null ? can(regex("^[A-z_0-9]+$", var.project_name)) : true
    error_message = "The project_name needs to be letters, numbers or underscores"
  }
}

variable "instance_type" {
  description = "Type of EC2 machine to create. Defaults to t2.nano"
  type        = string
  default     = "t2.nano"
}