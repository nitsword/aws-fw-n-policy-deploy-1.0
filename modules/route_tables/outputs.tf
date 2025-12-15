output "tg_route_table_id" {
  value = aws_route_table.tg_rt.id
}

output "firewall_route_table_id" {
  value = aws_route_table.firewall_rt.id
}