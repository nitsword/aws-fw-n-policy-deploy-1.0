variable "region" {
  description = "AWS region"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_tg_cidrs" {
  description = "CIDRs for private TG subnets"
  type        = list(string)
  default     = []
}

variable "private_firewall_cidrs" {
  description = "CIDRs for private firewall subnets"
  type        = list(string)
  default     = []
}

variable "private_tg_ipv6_cidrs" {
  description = "IPv6 CIDRs for private TG subnets"
  type        = list(string)
  default     = []
}

variable "private_firewall_ipv6_cidrs" {
  description = "IPv6 CIDRs for private firewall subnets"
  type        = list(string)
  default     = []
}

variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
  default     = "inspection-firewall"
}

variable "firewall_policy_name" {
  description = "Name of the firewall policy"
  type        = string
  default     = "inspection-firewall-policy"
}

variable "stateful_rule_group_arns" {
  description = "List of ARNs for stateful rule groups"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "List of public subnet IDs for the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = []
}

variable "firewall_endpoint_cidr" {
  description = "CIDR for the Network Firewall Endpoints"
  type        = string
}

variable "firewall_subnet_ids" {
  description = "List of existing subnet IDs where the firewall endpoints are deployed."
  type        = list(string)
}


variable "five_tuple_rg_capacity" {
  description = "Capacity for the 5-Tuple rule group."
  type        = number
}


variable "domain_rg_capacity" {
  description = "Capacity for the Domain rule group."
  type        = number
}

# variable "domain_rules" {
#   description = "List of domain filtering rules."
#   type = list(any)
#   default = []
# }

variable "allowed_domains_list" {
  description = "FQDNs/domains for targets in the Domain List rule group."
  type        = list(string)
  default     = [] 
}

variable "rules_csv_path" {
  description = "Relative path to the environment-specific rule CSV file."
  type        = string
}

variable "five_tuple_rules_csv_path" {
  description = "Relative path to a CSV file containing structured 5-tuple rules,The CSV should include these headers- action,protocol,source,source_port,destination,destination_port,msg,sid"
  type = string
  validation {
    condition     = length(var.five_tuple_rules_csv_path) > 0
    error_message = "five_tuple_rules_csv_path must be set and non-empty; provide a CSV with headers like action,protocol,source,source_port,destination,destination_port,msg,sid."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "application_ou_name" { type = string }
variable "environment" { type = string }

variable "base_tags" {
  type    = map(string)
  default = { "Created by" = "Cloud Network Team" }
}

# variable "firewall_endpoint_cidr" {
#   description = "CIDR block for the firewall endpoint"
#   type        = string
# }

# variable "firewall_endpoint_gw_id" {
#   description = "Gateway ID for the firewall endpoint"
#   type        = string
# }