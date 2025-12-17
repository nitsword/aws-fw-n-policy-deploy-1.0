## Subnet Derivation Locals
locals {
  vpc_ipv6_cidr = var.vpc_ipv6_cidr
  new_subnet_bits = 8
  firewall_index_offset = 100 
}



## Private Transit Gateway (TG) Subnets
resource "aws_subnet" "private_tg" {
  count                     = length(var.azs)
  vpc_id     = var.vpc_secondary_id
  cidr_block                = var.private_tg_cidrs[count.index]
  availability_zone         = var.azs[count.index]
  map_public_ip_on_launch   = false

  ipv6_cidr_block = cidrsubnet(
    local.vpc_ipv6_cidr,
    local.new_subnet_bits,
    count.index
  )
  assign_ipv6_address_on_creation = true

  tags = merge(
  {
    Name                  = "${var.application}-${var.env}-subnet-tg-${var.azs[count.index]}"
    "Resource Type"       = "subnet-tg"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}


## Private Network Firewall Subnets
resource "aws_subnet" "private_firewall" {
  count                     = length(var.azs)
  vpc_id     = var.vpc_secondary_id
  cidr_block                = var.private_firewall_cidrs[count.index]
  availability_zone         = var.azs[count.index]
  map_public_ip_on_launch   = false

  ipv6_cidr_block = cidrsubnet(
    local.vpc_ipv6_cidr,
    local.new_subnet_bits,
    count.index + local.firewall_index_offset
  )
  assign_ipv6_address_on_creation = true

  tags = merge(
  {
    Name                  = "${var.application}-${var.env}-subnet-fw-${var.azs[count.index]}"
    "Resource Type"       = "subnet-fw"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}


