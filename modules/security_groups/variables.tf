variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tg_ipv4_cidrs" {
  description = "List of IPv4 CIDRs for TG subnets"
  type        = list(string)
}

variable "tg_ipv6_cidrs" {
  description = "List of IPv6 CIDRs for TG subnets"
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