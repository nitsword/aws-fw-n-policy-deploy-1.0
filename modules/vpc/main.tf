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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.inspection_vpc.id

  tags = {
    Name = "inspection-vpc-igw"
  }
}

resource "aws_eip" "nat" {
  count = length(var.azs)

  tags = {
    Name = "inspection-vpc-nat-${count.index}"
  }
}

# resource "aws_subnet" "public" {
#   count             = length(var.public_subnet_cidrs)
#   vpc_id            = aws_vpc.inspection_vpc.id
#   cidr_block        = var.public_subnet_cidrs[count.index]
#   availability_zone = var.azs[count.index]

#   tags = {
#     Name = "inspection-vpc-public-subnet-${count.index}"
#   }
# }

resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  #subnet_id     = aws_subnet.public[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = {
    Name = "inspection-vpc-nat-${count.index}"
  }
}