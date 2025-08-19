output "ubuntu_ami_details" {
  description = "Details of the Ubuntu 24.04 LTS AMI."
  value = data.aws_ami.ubuntu_server_2404_lts.description
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance."
  value       = aws_instance.web_server.public_ip
}

output "access_url" {
  description = "URL to access the Nginx server."
  value       = "http://${aws_instance.web_server.public_ip}"
}
