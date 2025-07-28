variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "ap-northeast-1"
}

variable "ec2_key_name" {
  description = "Name of the EC2 Key Pair to allow SSH access."
  type        = string
  default     = "default-key-pair"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Name    = "simple-nginx-server"
    Owner   = "intern-inoue"
    Purpose = "nginx-web-server"
  }
}