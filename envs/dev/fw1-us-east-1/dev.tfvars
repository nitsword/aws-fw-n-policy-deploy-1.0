application = "ntw"
environment = "non-production::dev"
env = "dev"
region = "us-east-1"
azs = ["us-east-1a", "us-east-1b", "us-east-1d"]

vpc_cidr = "10.0.0.0/16"
secondary_cidr_blocks  = ["10.1.0.0/16"]
#transit_gateway_id = "tgw-00d08c76bf62baaa7"
transit_gateway_id = "tgw-09396a29da000e3c8"


private_tg_cidrs       = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_firewall_cidrs = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]

# Routing and Firewall Setup
firewall_endpoint_cidr = "0.0.0.0/0"
#firewall_name = "inspection-firewall-dev-us-east-1"
#irewall_policy_name = "inspection-firewall-policy-dev"

# dynamic variables
firewall_subnet_ids = [] 
stateful_rule_group_arns = [] 

# # TG subnet CIDRs for security group
tg_ipv4_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# tg_ipv6_cidrs = ["2600:1f18:abcd:1::/64", "2600:1f18:abcd:2::/64", "2600:1f18:abcd:3::/64"]
 