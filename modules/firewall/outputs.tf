output "firewall_endpoint_ip" {
  description = "Private IP address of the first Network Firewall endpoint ENI."
  value       = data.aws_network_interface.first_firewall_eni_ip_lookup.private_ip
}

output "firewall_endpoint_gateway_id" {
  description = "ID of the Network Firewall endpoint."
  value = [
    for state in aws_networkfirewall_firewall.inspection_firewall.firewall_status[0].sync_states : (
      state.attachment[0].endpoint_id
    )
  ][0]
}

output "firewall_arn" {
  description = "The ARN of the AWS Network Firewall resource."
  value       = aws_networkfirewall_firewall.inspection_firewall.arn
}

output "firewall_id" {
  description = "The ID of the AWS Network Firewall resource."
  value       = aws_networkfirewall_firewall.inspection_firewall.id
}

output "firewall_endpoint_cidr" {
  description = "The CIDR block that traffic is routed to."
  value       = var.firewall_endpoint_cidr
}


output "firewall_eni_ids" {
  description = "List of all Network Interface IDs created by the firewall."
  value = [
    for state in aws_networkfirewall_firewall.inspection_firewall.firewall_status[0].sync_states :
    state.attachment[0].endpoint_id
  ]
}

output "first_firewall_eni_id_for_route" {
  description = "The actual ENI ID (eni-xxx) of the first firewall endpoint for route tables."
  value       = data.aws_network_interface.first_firewall_eni_ip_lookup.id
}