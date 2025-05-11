variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for EC2"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "innerlens_website_db"
}

variable "db_user" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  type        = number
  description = "The port for the database"
}

variable "db_subnet_group" {
  description = "RDS subnet group name"
  type        = string
}

variable "db_security_group_id" {
  description = "Security Group ID for RDS"
  type        = string
}

variable "github_repo_url" {
  description = "GitHub repo to clone on EC2"
  type        = string
  default     = "https://github.com/example/project.git"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "jwt_secret_key" {
  description = "Secret key used for JWT token signing"
  type        = string
  sensitive   = true
}

variable "subnet_cidrs" {
  type        = string
  description = "Base CIDR block for VPC"
}

variable "app_name" {
  type        = string
  description = "Name of the application"
  default     = "innerlens-website-path-api"
}
