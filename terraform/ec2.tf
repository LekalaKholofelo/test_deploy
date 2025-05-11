resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  user_data              = file("${path.module}/scripts/user-data.sh")
  depends_on = [
    aws_secretsmanager_secret.db_secret,
    aws_secretsmanager_secret_version.db_secret_value,
    aws_db_instance.postgres
  ]

  tags = {
    Name = "innerlens-website"
  }
}
