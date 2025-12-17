resource "aws_vpc" "inspection_vpc" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = true
  enable_dns_hostnames           = true
  assign_generated_ipv6_cidr_block = var.ipv6_ipam_pool_id == null ? true : false

  # If in future using IPAM for the PRIMARY block:
  # ipv6_ipam_pool_id    = var.ipv6_ipam_pool_id
  # ipv6_netmask_length  = 56

  tags = merge(
  {
    Name                  = "${var.application}-${var.env}-inspection-vpc-${var.region}"
    "Resource Type"       = "inspection-vpc"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}

# --- NEW: Secondary IPv4 CIDR Associations ---
resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  for_each   = toset(var.secondary_cidr_blocks)
  vpc_id     = aws_vpc.inspection_vpc.id
  cidr_block = each.value
}

# Secondary IPv6 Association (Pick from IPAM or another pool)
resource "aws_vpc_ipv6_cidr_block_association" "secondary_ipv6" {
  count  = var.ipv6_ipam_pool_id != null ? 1 : 0
  vpc_id = aws_vpc.inspection_vpc.id

  ipv6_ipam_pool_id   = var.ipv6_ipam_pool_id
  ipv6_netmask_length = 56
}

