# Route Table for the Transit Gateway
resource "aws_route_table" "tg_rt" {
  vpc_id = var.vpc_id

  tags = merge(
  {
    Name                  = "${var.application_ou_name}-${var.environment}-tgw-rt-${var.region}"
    "Resource Type"       = "route-table-tgw"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application ou name" = var.application_ou_name
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}

# Route Table for the Firewall Subnets
resource "aws_route_table" "firewall_rt" {
  vpc_id = var.vpc_id

  tags = merge(
  {
    Name                  = "${var.application_ou_name}-${var.environment}-fw-rt-${var.region}"
    "Resource Type"       = "route-table-fw"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application ou name" = var.application_ou_name
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}

# Subnet associations for the firewall subnets
resource "aws_route_table_association" "firewall_assoc" {
  count          = length(var.firewall_subnet_ids)
  subnet_id      = var.firewall_subnet_ids[count.index]
  route_table_id = aws_route_table.firewall_rt.id
}

resource "aws_route" "firewall_endpoint_route" {
  route_table_id         = aws_route_table.firewall_rt.id
  destination_cidr_block = var.firewall_endpoint_cidr

  network_interface_id   = var.first_firewall_eni_id
}


# commented out TG route
# resource "aws_route" "tg_route" {
#    route_table_id         = aws_route_table.tg_rt.id
#    destination_cidr_block = var.tg_destination_cidr
#    gateway_id             = var.tg_gateway_id
# }