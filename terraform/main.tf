provider "aws" {
  region = "af-south-1"
}

module "ec2" {
  source = "./ec2"
}

module "rds" {
  source = "./rds"
}

module "secrets" {
  source = "./secrets"
}