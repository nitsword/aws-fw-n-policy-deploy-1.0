output "private_tg_subnet_ids" {
  value = aws_subnet.private_tg[*].id
}

output "private_tg_subnets" {
  description = "The full resource objects for the TG subnets"
  value       = aws_subnet.private_tg
}

output "private_firewall_subnet_ids" {
  value = aws_subnet.private_firewall[*].id
}

output "private_tg_subnet_ipv6_prefixes" {
  description = "The IPv6 CIDR blocks assigned to the private TG subnets"
  value       = aws_subnet.private_tg[*].ipv6_cidr_block
}

# output "public_subnet_ids" {
#   value       = aws_subnet.public.*.id
#   description = "List of public subnet IDs"
# }

