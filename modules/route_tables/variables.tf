variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "firewall_subnet_ids" {
  description = "List of firewall subnet IDs"
  type        = list(string)
}

variable "firewall_endpoint_cidr" {
  description = "Firewall endpoint IP address"
  type        = string
}

variable "firewall_endpoint_gateway_id" {
  description = "Firewall endpoint gateway ID"
  type        = string
}


variable "firewall_eni_id_for_route" {
  description = "Network Interface ID of Firewall endpoint for route target."
  type        = string
}

variable "first_firewall_eni_id" {
  description = "The ENI ID Network Firewall endpoint, for route target."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "application_ou_name" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "base_tags" { type = map(string) }