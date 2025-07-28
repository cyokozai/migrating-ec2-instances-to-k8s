output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.web_server.public_ip
}

output "access_url" {
  description = "URL to access the Nginx server."
  value       = "http://${aws_instance.web_server.public_ip}"
}