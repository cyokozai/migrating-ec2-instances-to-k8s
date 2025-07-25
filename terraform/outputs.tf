output "wordpress_url" {
  description = "The URL to access the WordPress site."
  value       = "http://${aws_lb.main.dns_name}"
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "rds_endpoint" {
  description = "The endpoint of the RDS database instance."
  value       = aws_db_instance.wordpress.endpoint
}