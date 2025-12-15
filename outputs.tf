# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

output "private_tg_subnet_ids" {
  value = module.subnets.private_tg_subnet_ids
}

output "private_firewall_subnet_ids" {
  value = module.subnets.private_firewall_subnet_ids
}

output "firewall_id" {
  value = module.firewall.firewall_id
}

output "firewall_arn" {
  value = module.firewall.firewall_arn
}

output "vpc_ipv6_cidr_block" {
  description = "The primary IPv6 CIDR block assigned to the VPC."
  value       = module.vpc.vpc_ipv6_cidr_block 
}