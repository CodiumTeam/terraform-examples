output "public_ips" {
  description = "IP of the created EC2 instance"
  value       = { for instance in sort(keys(var.ubuntu_instances)) : instance => module.ubuntu_ec2[instance].public_ip }
}
