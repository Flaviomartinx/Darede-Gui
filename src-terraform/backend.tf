provider "aws" {
  region = var.region_aws1
}

module "VPC" {
  source = "./modules/VPC"
}

module "WAF" {
  source = "./modules/WAF"
}