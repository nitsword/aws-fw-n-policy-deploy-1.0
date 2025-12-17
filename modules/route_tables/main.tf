
# 1. Route tables for private_tg subnets (one per subnet)
resource "aws_route_table" "private_tg" {
  count  = length(var.private_tg_subnet_ids)
  vpc_id = var.vpc_id
  tags = merge({
    Name = "${var.application}-${var.env}-tg-rt-${var.private_tg_subnets_full[count.index].availability_zone}"
    "Resource Type" = "route-table-tg"
    "Creation Date" = timestamp()
    "Environment" = var.environment
    "Application" = var.application
    "Created by" = "Cloud Network Team"
    "Region" = var.region
  }, var.base_tags)
}

# Route 0.0.0.0/0 in each private_tg route table to firewall endpoint in same AZ
resource "aws_route" "private_tg_default_to_fw" {
  count = length(var.private_tg_subnet_ids)
  route_table_id         = aws_route_table.private_tg[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id = lookup(
    var.firewall_endpoint_map, 
    var.private_tg_subnets_full[count.index].availability_zone
  )
}

resource "aws_route" "private_tg_default_v6_to_fw" {
  count = length(var.private_tg_subnet_ids)
  route_table_id              = aws_route_table.private_tg[count.index].id
  destination_ipv6_cidr_block = "::/0"
  vpc_endpoint_id = lookup(
    var.firewall_endpoint_map, 
    var.private_tg_subnets_full[count.index].availability_zone
  )
}

# Associate each private_tg subnet with its route table
resource "aws_route_table_association" "private_tg_assoc" {
  count          = length(var.private_tg_subnet_ids)
  subnet_id      = var.private_tg_subnet_ids[count.index]
  route_table_id = aws_route_table.private_tg[count.index].id
}

# 2. Single route table for all private_firewall subnets
resource "aws_route_table" "firewall" {
  vpc_id = var.vpc_id
  tags = merge({
    Name = "${var.application}-${var.env}-fw-rt-${var.region}"
    "Resource Type" = "route-table-fw"
    "Creation Date" = timestamp()
    "Environment" = var.environment
    "Application" = var.application
    "Created by" = "Cloud Network Team"
    "Region" = var.region
  }, var.base_tags)
}

# Route 0.0.0.0/0 in firewall route table to transit gateway
resource "aws_route" "firewall_default_to_tgw" {
  route_table_id         = aws_route_table.firewall.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id
  depends_on = [var.tgw_attachment_id]
}

# Route 0.0.0.0/0 in firewall route table to transit gateway
resource "aws_route" "firewall_default_v6_to_tgw" {
  route_table_id         = aws_route_table.firewall.id
  destination_ipv6_cidr_block = "::/0"
  transit_gateway_id     = var.transit_gateway_id
  depends_on = [var.tgw_attachment_id]
}

# Associate all private_firewall subnets with the firewall route table
resource "aws_route_table_association" "firewall_assoc" {
  count          = length(var.private_firewall_subnet_ids)
  subnet_id      = var.private_firewall_subnet_ids[count.index]
  route_table_id = aws_route_table.firewall.id
}

# resource "aws_route" "firewall_to_tgw" {
#   route_table_id         = aws_route_table.firewall_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   transit_gateway_id     = var.tgw_id
# }


# commented out TG route
# resource "aws_route" "tg_route" {
#    route_table_id         = aws_route_table.tg_rt.id
#    destination_cidr_block = var.tg_destination_cidr
#    gateway_id             = var.tg_gateway_id
# }