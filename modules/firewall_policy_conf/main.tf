locals {
  denylist_arn_list = var.enable_domain_denylist ? [one(aws_networkfirewall_rule_group.domain_denylist[*].arn)] : []
  allowlist_arn_list = var.enable_domain_allowlist ? [one(aws_networkfirewall_rule_group.domain_allowlist[*].arn)] : []
}

// -------------------------------------------------------------------------
// Stateful Rule Group: 5-Tuple
// -------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "five_tuple_rule_group" {
  name        = "five-tuple-rg-${var.firewall_policy_name}"
  description = "Standard 5-tuple rule group using Suricata string."
  type        = "STATEFUL"
  capacity    = var.five_tuple_rg_capacity

  rule_group {
    stateful_rule_options {
      rule_order = var.stateful_rule_order
    }

    rules_source {
      rules_string = var.five_tuple_rules_string
    }
  }

  tags = merge(
  {
    Name                  = "${var.application}-${var.env}-five-tuple-rg-${var.region}"
    "Resource Type"       = "five tuple rg"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}

// -------------------------------------------------------------------------
// Stateful Rule Group: Domain DENYLIST
// -------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "domain_denylist" {
  count       = var.enable_domain_denylist ? 1 : 0
  name        = "domain-denylist-${var.firewall_policy_name}"
  description = "Domain denylist rule group (AWS-managed FQDN filtering)."
  type        = "STATEFUL"
  capacity    = var.domain_rg_capacity

  rule_group {
    stateful_rule_options {
      rule_order = var.stateful_rule_order
    }

    rules_source {
      rules_source_list {
        targets              = var.denied_domains_list
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        generated_rules_type = "DENYLIST"
      }
    }
  }

  tags = {
    Name = "Domain-RG-Denylist"
  }
}

// -------------------------------------------------------------------------
// Stateful Rule Group: Domain ALLOWLIST
// -------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "domain_allowlist" {
  count       = var.enable_domain_allowlist ? 1 : 0
  name        = "domain-allowlist-${var.firewall_policy_name}"
  description = "Domain allowlist rule group (AWS-managed FQDN filtering)."
  type        = "STATEFUL"
  capacity    = var.domain_rg_capacity

  rule_group {
    //Required for STRICT_ORDER policies
    stateful_rule_options {
      rule_order = var.stateful_rule_order
    }

    rules_source {
      rules_source_list {
        targets              = var.allowed_domains_list
        target_types         = ["TLS_SNI", "HTTP_HOST"]
        generated_rules_type = "ALLOWLIST"
      }
    }
  }

tags = merge(
  {
    Name                  = "${var.application}-${var.env}-domain-allow-rg-${var.region}"
    "Resource Type"       = "domain-allow-rg"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}

// -------------------------------------------------------------------------
// Network Firewall Policy
// -------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "firewall_policy" {
  name = var.firewall_policy_name

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:drop"]

    // Domain DENYLIST
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order == "STRICT_ORDER" && length(local.denylist_arn_list) > 0 ? { rule : local.denylist_arn_list[0] } : {}
      content {
        resource_arn = stateful_rule_group_reference.value
        priority     = var.priority_domain_denylist
      }
    }
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order != "STRICT_ORDER" && length(local.denylist_arn_list) > 0 ? { rule : local.denylist_arn_list[0] } : {}
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }

    //  Domain ALLOWLIST
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order == "STRICT_ORDER" && length(local.allowlist_arn_list) > 0 ? { rule : local.allowlist_arn_list[0] } : {}
      content {
        resource_arn = stateful_rule_group_reference.value
        priority     = var.priority_domain_allowlist
      }
    }
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order != "STRICT_ORDER" && length(local.allowlist_arn_list) > 0 ? { rule : local.allowlist_arn_list[0] } : {}
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }

    // 5-Tuple rules
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order == "STRICT_ORDER" ? { rg = aws_networkfirewall_rule_group.five_tuple_rule_group } : {}
      content {
        resource_arn = stateful_rule_group_reference.value.arn
        priority     = var.priority_five_tuple
      }
    }
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order != "STRICT_ORDER" ? { rg = aws_networkfirewall_rule_group.five_tuple_rule_group } : {}
      content {
        resource_arn = stateful_rule_group_reference.value.arn
      }
    }

    stateful_engine_options {
      rule_order = var.stateful_rule_order
    }

    // Additional external stateful rule groups
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order != "STRICT_ORDER" ? var.stateful_rule_group_arns : []
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_order == "STRICT_ORDER" ? var.stateful_rule_group_objects : []
      content {
        resource_arn = stateful_rule_group_reference.value.arn
        priority     = stateful_rule_group_reference.value.priority
      }
    }
  }

tags = merge(
  {
    Name                  = "${var.application}-${var.env}-firewall-policy-${var.region}"
    "Resource Type"       = "firewall-policy"
    "Creation Date"       = timestamp()
    "Environment"         = var.environment
    "Application" = var.application
    "Created by"          = "Cloud Network Team"
    "Region"              = var.region
  },var.base_tags
)
}