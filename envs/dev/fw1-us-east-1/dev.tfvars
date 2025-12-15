application_ou_name = "ntw"
environment = "dev"
region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
azs = ["us-east-1a", "us-east-1b", "us-east-1d"]

public_subnet_cidrs = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]

private_tg_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_firewall_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# Routing and Firewall Setup
firewall_endpoint_cidr = "0.0.0.0/0"
firewall_name = "inspection-firewall-dev"
#irewall_policy_name = "inspection-firewall-policy-dev"

# dynamic variables
firewall_subnet_ids = [] 
stateful_rule_group_arns = [] 

# TG subnet CIDRs for security group
tg_ipv4_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
tg_ipv6_cidrs = ["2600:1f18:abcd:1::/64", "2600:1f18:abcd:2::/64", "2600:1f18:abcd:3::/64"]