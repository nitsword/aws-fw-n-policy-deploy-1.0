    terraform {
    required_version = ">= 1.3.0"

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.54"
        }
    }
    }

    provider "aws" {
    region = var.region
    }

        locals {
    domain_list_data = csvdecode(file(var.rules_csv_path))
    allowed_domains = [
    for d in local.domain_list_data : d.domain
    if upper(trimspace(d.action)) == "ALLOW"
  ]

  denied_domains = [
    for d in local.domain_list_data : d.domain
    if upper(trimspace(d.action)) == "DENY"
  ]


    #  5-tuple CSV and build Suricata rule strings.
    # Expected CSV headers: action,protocol,source,source_port,destination,destination_port,msg,sid
    five_tuple_rules_data = csvdecode(file(var.five_tuple_rules_csv_path))

    five_tuple_rules_string = join("\n", [
        for r in local.five_tuple_rules_data :
        format(
            "%s %s %s %s -> %s %s (msg:\"%s\";%s flow:to_server;)",
            lookup(r, "action", "pass"),
            lower(lookup(r, "protocol", "tcp")),
            lookup(r, "source", "ANY"),
            lookup(r, "source_port", "ANY"),
            lookup(r, "destination", "ANY"),
            lookup(r, "destination_port", "ANY"),
            replace(lookup(r, "msg", "Generated rule"), "\"", "\\\""),
            length(trimspace(lookup(r, "sid", ""))) > 0 ? format("sid:%s;", lookup(r, "sid", "")) : ""
        )
    ])
}

    module "vpc" {
    source              = "./modules/vpc"
    vpc_cidr            = var.vpc_cidr
    azs                 = var.azs
    application_ou_name = var.application_ou_name
    environment         = var.environment
    region              = var.region
    base_tags           = var.base_tags
    public_subnet_ids   = module.subnets.public_subnet_ids
    public_subnet_cidrs = var.public_subnet_cidrs
    }

    module "subnets" {
    source                  = "./modules/subnets"
    vpc_id                  = module.vpc.vpc_id
    azs                     = var.azs
    application_ou_name = var.application_ou_name
    environment         = var.environment
    region              = var.region
    base_tags           = var.base_tags
    private_tg_cidrs        = var.private_tg_cidrs
    private_firewall_cidrs  = var.private_firewall_cidrs
    public_subnet_cidrs     = var.public_subnet_cidrs
    vpc_ipv6_cidr           = module.vpc.vpc_ipv6_cidr_block
    }

    module "security_groups" {
    source        = "./modules/security_groups"
    vpc_id        = module.vpc.vpc_id
    application_ou_name = var.application_ou_name
    environment         = var.environment
    region              = var.region
    base_tags           = var.base_tags
    tg_ipv4_cidrs = var.private_tg_cidrs
    tg_ipv6_cidrs = var.private_tg_ipv6_cidrs
    }

    module "firewall_policy_conf" {
    source = "./modules/firewall_policy_conf"
    environment          = var.environment 
    firewall_policy_name = var.firewall_policy_name
    five_tuple_rg_capacity  = var.five_tuple_rg_capacity
    five_tuple_rules_string = local.five_tuple_rules_string
    domain_rg_capacity      = var.domain_rg_capacity
    stateful_rule_group_arns = var.stateful_rule_group_arns
    stateful_rule_order     = var.stateful_rule_order
    stateful_rule_group_objects = var.stateful_rule_group_objects
    enable_domain_allowlist   = length(local.allowed_domains) > 0
    allowed_domains_list      = local.allowed_domains
    enable_domain_denylist    = length(local.denied_domains) > 0
    denied_domains_list       = local.denied_domains
    priority_domain_denylist  = var.priority_domain_denylist
    priority_domain_allowlist = var.priority_domain_allowlist
    priority_five_tuple       = var.priority_five_tuple
}

    module "firewall" {
    source                          = "./modules/firewall"
    application_ou_name = var.application_ou_name
    environment         = var.environment
    region              = var.region
    base_tags           = var.base_tags
    firewall_name                   = var.firewall_name
    firewall_policy_name            = var.firewall_policy_name
    vpc_id                          = module.vpc.vpc_id
    firewall_subnet_ids             = module.subnets.private_firewall_subnet_ids
    firewall_sg_id                  = module.security_groups.firewall_sg_id
    firewall_endpoint_cidr          = var.firewall_endpoint_cidr
    firewall_policy_arn = module.firewall_policy_conf.firewall_policy_arn
}

module "route_tables" {
    source                          = "./modules/route_tables"

    vpc_id                          = module.vpc.vpc_id
    application_ou_name = var.application_ou_name
    environment         = var.environment
    region              = var.region
    base_tags           = var.base_tags
    firewall_subnet_ids             = module.subnets.private_firewall_subnet_ids
    
    firewall_endpoint_cidr          = module.firewall.firewall_endpoint_cidr
    firewall_endpoint_gateway_id    = module.firewall.firewall_endpoint_gateway_id 
    first_firewall_eni_id           = module.firewall.first_firewall_eni_id_for_route
    firewall_eni_id_for_route       = ""
}