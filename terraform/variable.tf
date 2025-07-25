variable "project_name" {
  description = "Name for the project, used as a prefix for resources."
  type        = string
  default     = "wp-demo"
}

variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type for WordPress nodes."
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "Name of the EC2 Key Pair to allow SSH access."
  type        = string
}

variable "db_name" {
  description = "Name for the WordPress database."
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "Username for the WordPress database."
  type        = string
  default     = "wpadmin"
}

variable "db_password" {
  description = "Password for the WordPress database."
  type        = string
  sensitive   = true
}
