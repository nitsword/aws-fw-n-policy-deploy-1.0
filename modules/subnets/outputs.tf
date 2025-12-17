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

# output "public_subnet_ids" {
#   value       = aws_subnet.public.*.id
#   description = "List of public subnet IDs"
# }

