output "public_ips" {
  description = "IP of the created EC2 instance"
  value       = module.nginx.public_ips
}
