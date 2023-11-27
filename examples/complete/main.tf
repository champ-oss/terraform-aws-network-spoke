resource "aws_vpc_ipam" "this" {
  count = 1

  operating_regions {
    region_name = "us-east-2"
  }
}

resource "aws_vpc_ipam_scope" "this" {
  count   = 1
  ipam_id = aws_vpc_ipam.this[0].id
}

resource "aws_vpc_ipam_pool" "this" {
  count                             = 1
  ipam_scope_id                     = aws_vpc_ipam_scope.this[0].id
  source_ipam_pool_id               = aws_vpc_ipam_pool.this[0].id
  address_family                    = "ipv4"
  locale                            = "us-east-2"
  allocation_default_netmask_length = 18
  allocation_min_netmask_length     = 18
  allocation_max_netmask_length     = 18
}

resource "aws_vpc_ipam_pool_cidr" "this" {
  count          = 1
  ipam_pool_id   = aws_vpc_ipam_pool.this[0].id
  netmask_length = 12
  cidr           = "10.0.0.0/8"
}

resource "aws_ec2_transit_gateway" "this" {
  count                          = 1
  auto_accept_shared_attachments = "enable"
}

module "this" {
  source             = "../../"
  ipv4_ipam_pool_id  = aws_vpc_ipam_pool.this[0].id
  transit_gateway_id = aws_ec2_transit_gateway.this[0].id
}