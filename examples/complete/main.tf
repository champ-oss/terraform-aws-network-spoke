module "this" {
  source                = "../../"
  enabled               = var.enabled
  name                  = "network-spoke"
  enable_discover_ipam  = false
  vpc_ipv4_ipam_pool_id = try(module.ipam[0].pools_level_1["us-east-2"].id, null)
  transit_gateway_id    = try(aws_ec2_transit_gateway.this[0].id, null)

  ingress_acl_rules = [
    { cidr_block = "10.1.0.0/16" },
    { cidr_block = try(module.hub[0].vpc_attributes.cidr_block, null) }
  ]
}

variable "enabled" {
    description = "Set to false to prevent the module from creating any resources"
    type        = bool
    default     = false
}
