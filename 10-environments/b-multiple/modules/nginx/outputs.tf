output "public_ips" {
  value = { for k in sort(keys(var.instances)) : k => aws_instance.this[k].public_ip }
}