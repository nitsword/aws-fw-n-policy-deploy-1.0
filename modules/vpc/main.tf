resource "aws_vpc" "inspection_vpc" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = true
  enable_dns_hostnames           = true
  assign_generated_ipv6_cidr_block = true

  tags = merge(
  {
    Name                  = "${var.application_ou_name}-${var.environment}-vpc-${var.region}"
    "Resource Type"       = "vpc"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application ou name" = var.application_ou_name
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}

