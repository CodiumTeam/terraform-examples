variable "instance" {
  description = "Configuration for the EC2 instance"
  type = object({
    key_name          = string
    subnet_id         = string
    type              = string
    security_group_id = string
    tags              = map(string)
  })
}
