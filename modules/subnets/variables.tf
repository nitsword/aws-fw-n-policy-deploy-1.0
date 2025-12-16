## modules/subnets/variables.tf

variable "vpc_id" {
  description = "VPC ID"
  type        = string
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

variable "application_ou_name" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "base_tags" { type = map(string) }