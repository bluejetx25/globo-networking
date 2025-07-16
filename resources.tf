##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  region = var.region
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################
locals {
  common_tags = {
    
  }
}

module "main" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.prefix
  cidr = var.cidr_block

  azs                     = slice(data.aws_availability_zones.available.names, 0, length(var.private_subnets))
  private_subnets          = [for k, v in var.private_subnets : v]
  private_subnet_names     = [for k, v in var.private_subnets : "${var.prefix}-${k}"]
  enable_dns_hostnames    = true
  private_subnet_suffix    = ""
  private_route_table_tags = { Name = "${var.prefix}-private" }
  # map_private_ip_on_launch = true

  # enable_nat_gateway = false

  tags = local.common_tags
}