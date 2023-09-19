output "public_ip" {
  description = "IP of the created EC2 instance"
  value       = aws_instance.this.public_ip
}

output "password" {
  description = "Password of the created EC2 instance"
  value       = aws_instance.this.password_data
}