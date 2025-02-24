output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
output "public_ip" {
  description = "public instance id"
  value       = aws_instance.public_instance[*].public_ip
}

output "db_endpoint" {
  value = aws_db_instance.postgres_db.address
}