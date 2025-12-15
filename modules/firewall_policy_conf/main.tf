# -------------------------------------------------------------------------
# Stateful Rule Group: 5-Tuple 
# -------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "five_tuple_rule_group" {
  name        = "five-tuple-rg-${var.firewall_policy_name}"
  description = "Standard 5-tuple rule group using Suricata string."
  type        = "STATEFUL"
  capacity    = var.five_tuple_rg_capacity

  rule_group {
    rules_source {
      rules_string = var.five_tuple_rules_string
    }
  }

  tags = {
    Name = "5-Tuple-RG"
  }
}

# -------------------------------------------------------------------------
# Stateful Rule Group: Domain Rules
# -------------------------------------------------------------------------
resource "aws_networkfirewall_rule_group" "domain_rule_group" {
  name        = "domain-rg-${var.firewall_policy_name}"
  description = "Rule group for FQDN/Domain list filtering (native AWS feature)."
  type        = "STATEFUL"
  capacity    = var.domain_rg_capacity

  rule_group {
    rules_source {
      rules_source_list {
        targets = var.allowed_domains_list
        target_types = ["TLS_SNI", "HTTP_HOST"] 
        generated_rules_type = "ALLOWLIST"
      }
    }
  }

  tags = {
    Name = "Domain-RG-List"
  }
}

# -------------------------------------------------------------------------
# 3. Network Firewall Policy
# -------------------------------------------------------------------------
resource "aws_networkfirewall_firewall_policy" "firewall_policy" {
  name = var.firewall_policy_name

  firewall_policy {
    # Forward stateless traffic to stateful engine (Inspect)
    stateless_default_actions      = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:drop"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.five_tuple_rule_group.arn
      #priority     = 10
    }

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.domain_rule_group.arn
      #priority     = 20
    }

    dynamic "stateful_rule_group_reference" {
      for_each = var.stateful_rule_group_arns
      content {
        resource_arn = stateful_rule_group_reference.value
      }
    }
  }

  tags = {
    Name = var.firewall_policy_name
  }
}