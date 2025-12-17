## modules/subnets/variables.tf

# variable "vpc_id" {
#   description = "VPC ID"
#   type        = string
# }

variable "vpc_secondary_id" {
  type        = string
  description = "The VPC ID associated with secondary CIDR blocks"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_ipv6_cidr" {
  description = "The primary IPv6 CIDR block assigned to the VPc"
  type        = string
}

variable "private_tg_cidrs" {
  description = "List of IPv4 CIDRs for private TG subnets"
  type        = list(string)
}

variable "private_firewall_cidrs" {
  description = "List of IPv4 CIDRs for private firewall subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

# variable "private_tg_subnets_full" {
#   description = "The list of full subnet objects from the subnets module"
# }

variable "application" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "base_tags" { type = map(string) }
variable "env" { type = string }