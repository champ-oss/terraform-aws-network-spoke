module "vpc" {
  count                    = 1
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=32b6e9c73f498f061e378ba4dc4cb157190c25f6"
  name                     = var.name
  cidr_block               = null
  cidr_size                = null
  subnet_size              = var.subnet_size
  availability_zones_count = var.availability_zones_count
  ipv4_ipam_pool_id        = data.aws_vpc_ipam_pool.this[0].id
  ipv4_netmask_length      = null
  transit_gateway_id       = var.transit_gateway_id
  create_nat_gw            = false
  tags                     = merge(local.tags, var.tags)
}