output "vpc_id" {
  value = aws_vpc.inspection_vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.nat[*].id
}

output "vpc_ipv6_cidr_block" { 
  value = aws_vpc.inspection_vpc.ipv6_cidr_block 
}