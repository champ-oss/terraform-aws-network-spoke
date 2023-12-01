module "this" {
  source                = "../../"
  name                  = "network-spoke"
  enable_discover_ipam  = false
  vpc_ipv4_ipam_pool_id = module.ipam[0].pools_level_1["us-east-2"].id
  transit_gateway_id    = aws_ec2_transit_gateway.this[0].id

  ingress_acl_rules = [
    { cidr_block = "10.1.0.0/16" },
    { cidr_block = module.hub[0].vpc_attributes.cidr_block }
  ]
  # Resulting VPC Network ACL:
  # rule_no|cidr_block|action|description
  # 1 <local cidr> Allow (var.enable_ingress_local_allow = true)
  # 2 10.1.0.0/16  Allow (var.ingress_acl_rules)
  # 3 <hub cidr>   Allow (var.ingress_acl_rules)
  # 4 10.0.0.0/8   Deny  (var.enable_ingress_cidr_deny = true)
  # 5 0.0.0.0/0    Allow (var.enable_ingress_implicit_allow = true)
}
