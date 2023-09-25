variable "naming_prefix" {
  description = "Prefix used to named resources"
  type        = string
}

variable "availability_zone_count" {
  description = "Number of availability zones where to deploy subnets"
  type        = number
  default     = 1
}