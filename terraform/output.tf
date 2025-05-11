output "ec2_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP of the EC2 instance"
}

output "ec2_public_dns" {
  value       = aws_instance.web_server.public_dns
  description = "Public DNS name of the EC2 instance"
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "The endpoint of the RDS instance"
}

output "secret_arn" {
  value       = aws_secretsmanager_secret.db_secret.arn
  description = "ARN of the database secret in Secrets Manager"
}
