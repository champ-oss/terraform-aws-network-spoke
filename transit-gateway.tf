resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  count              = 1
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = module.vpc[0].vpc_id
  subnet_ids         = module.vpc[0].private_subnets_ids
  tags               = merge({ Name : var.name }, local.tags, var.tags)
}