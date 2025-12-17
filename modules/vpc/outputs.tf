output "vpc_id" {
  value = aws_vpc.inspection_vpc.id
}

output "vpc_secondary_cidr_id" {
  description = "The VPC ID, exported only after secondary CIDR association is complete"
  value       = values(aws_vpc_ipv4_cidr_block_association.secondary_cidr)[0].vpc_id
}

output "vpc_ipv6_cidr_block" { 
  value = aws_vpc.inspection_vpc.ipv6_cidr_block 
}

output "vpc_secondary_cidr_ids" {
  value = [for assoc in aws_vpc_ipv4_cidr_block_association.secondary_cidr : assoc.vpc_id]
}