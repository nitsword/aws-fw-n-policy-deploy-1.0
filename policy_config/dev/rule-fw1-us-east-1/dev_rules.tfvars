environment          = "dev"
firewall_policy_name = "inspection-firewall-policy-dev"

# --- 5-Tuple Rule Group Content ---

five_tuple_rg_capacity  = 100
# Provide a CSV file containing 5-tuple Suricata rule strings (header: rule).
# When set, Terraform will read and join the `rule` column into the
# `five_tuple_rules_string` used by the module.
five_tuple_rules_csv_path = "policy_config/dev/rule-fw1-us-east-1/five_tuple_rules.csv"

# Path to the domain rules CSV (domains list) used by the root module
# CSV should have headers: domain,description
rules_csv_path = "policy_config/dev/rule-fw1-us-east-1/dev_rules.csv"

# --- Domain Rule Group (FQDN) Inputs ---

domain_rg_capacity = 100

# Complex structured rules (used for testing)
# domain_rules = [
#  {
#     priority     = 10
#     action   = "PASS"
#     protocol     = "TCP"
#     source   = "ANY"
#     source_port = "ANY"
#     destination = "ANY" 
#     destination_port = "443"
#     direction = "FORWARD"
#     rule_options = [
#     {
#     keyword = "sid"
#     settings = ["2000001"]
#     },
#     {
#     keyword = "tls_sni"
#     settings = [".amazon.com"] 
# }
#     ]
#   },
#   {
#     priority     = 20
#     action   = "DROP"
#     protocol  = "TCP"
#     source  = "ANY"
#     source_port = "ANY"
#     destination = "ANY"
#     destination_port = "22"
#     direction   = "FORWARD"
#     rule_options    = [
#   {
#     keyword = "sid"
#     settings = ["2000002"]
#     }
#     ]
#   }
# ]