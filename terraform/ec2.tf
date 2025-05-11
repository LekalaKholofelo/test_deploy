resource "aws_instance" "node_backend" {
  ami           = "ami-0bb4c991fa89d4b9b" # Amazon Linux 2 (x86_64) - af-south-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name      = var.ec2_key_pair_name

  user_data = file("${path.module}/scripts/user-data.sh")

  tags = {
    Name = "StellarPath-NodeBackend"
  }
}