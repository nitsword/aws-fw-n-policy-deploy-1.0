output "vpc_id" {
  value = aws_vpc.inspection_vpc.id
}



output "vpc_ipv6_cidr_block" { 
  value = aws_vpc.inspection_vpc.ipv6_cidr_block 
}