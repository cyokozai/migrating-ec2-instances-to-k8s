variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "ap-northeast-1"
}

variable "ec2_key_name" {
  description = "Name of the EC2 Key Pair to allow SSH access."
  type        = string
}