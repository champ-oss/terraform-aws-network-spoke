module "this" {
  source                = "../../"
  name                  = "network-spoke"
  enable_discover_ipam  = false
  vpc_ipv4_ipam_pool_id = module.ipam[0].pools_level_1["us-east-2"].id
  transit_gateway_id    = aws_ec2_transit_gateway.this[0].id
}
