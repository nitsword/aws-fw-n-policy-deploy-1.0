variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "ipv6_ipam_pool_id" {
  description = "The ID of the IPAM pool to use for IPv6 (empty for Amazon default)"
  type        = string
  default     = null
}

variable "use_amazon_ipv6_pool" {
  description = "Set to true to use Amazon's default IPv6 pool"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "secondary_cidr_blocks" {
  type        = list(string)
  description = "List of secondary IPv4 CIDR blocks for the VPC"
  default     = []
}

variable "application" { type = string }
variable "environment" { type = string }
variable "region" { type = string }
variable "base_tags" { type = map(string) }
variable "env" { type = string }