variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

# variable "public_subnets" {
#   description = "List of public subnet IDs for NAT gateways"
#   type        = list(string)
# }

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs created by the subnets module."
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