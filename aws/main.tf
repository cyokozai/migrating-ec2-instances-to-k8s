terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46.0"
    }
  }

  backend "s3" {
    bucket         = "yinoue-terraform-statefile"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }

  # backend "local" {}
}


provider "aws" {
  region = var.aws_region
}


data "aws_ami" "ubuntu_server_2404_lts" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu_server_2404_lts.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.ec2_key_name

  user_data = <<-EOF
              #!/bin/bash
              apt -y update
              apt -y install nginx
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = var.common_tags
}