output "public_ip" {
  description = "IP of the created EC2 instance"
  value       = module.ubuntu_ec2.public_ip
}
