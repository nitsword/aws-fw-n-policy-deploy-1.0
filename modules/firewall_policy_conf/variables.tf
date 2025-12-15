variable "firewall_policy_name" {
  description = "Name for the AWS Network Firewall policy."
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, prod)."
  type        = string
}

# -------------------------------------------------------------------------
# 5-Tuple Stateful Rule Group Inputs
# -------------------------------------------------------------------------
variable "five_tuple_rg_capacity" {
  description = "Capacity for the 5-tuple stateful rule group."
  type        = number
}

variable "five_tuple_rules_string" {
  description = "Suricata-compatible rules string for 5-tuple inspection."
  type        = string
}

# -------------------------------------------------------------------------
# Domain Rule Groups (FQDN-based)
# -------------------------------------------------------------------------
variable "domain_rg_capacity" {
  description = "Capacity for domain-based rule groups (allowlist/denylist)."
  type        = number
}

variable "enable_domain_allowlist" {
  description = "Enable AWS-managed domain allowlist (FQDN filtering)."
  type        = bool
  default     = false
}

variable "allowed_domains_list" {
  description = "List of allowed FQDNs (used when enable_domain_allowlist = true)."
  type        = list(string)
  default     = []
}

variable "enable_domain_denylist" {
  description = "Enable AWS-managed domain denylist (FQDN filtering)."
  type        = bool
  default     = false
}

variable "denied_domains_list" {
  description = "List of denied FQDNs (used when enable_domain_denylist = true)."
  type        = list(string)
  default     = []
}

variable "stateful_rule_group_arns" {
  description = "List of additional stateful rule group ARNs to attach."
  type        = list(string)
  default     = []
}

variable "stateful_rule_order" {
  description = "Stateful rule evaluation order for AWS Network Firewall."
  type        = string
  default     = "STRICT_ORDER"
}

variable "stateful_rule_group_objects" {
  description = "List of objects with ARN and priority"
  type = list(object({ arn = string, priority = number }))
  default = []
}


variable "priority_domain_denylist" {
  description = "Priority for the internal Domain DENYLIST rule group (used in STRICT_ORDER)."
  type        = number
}

variable "priority_domain_allowlist" {
  description = "Priority for the internal Domain ALLOWLIST rule group (used in STRICT_ORDER)."
  type        = number
}

variable "priority_five_tuple" {
  description = "Priority for the internal 5-Tuple rule group (used in STRICT_ORDER)."
  type        = number
}