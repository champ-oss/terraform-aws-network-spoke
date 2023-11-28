module "ipam" {
  source   = "github.com/aws-ia/terraform-aws-ipam?ref=v2.1.0"
  count    = 1
  top_cidr = ["10.0.0.0/8"]
  top_name = "global"

  pool_configurations = {
    us-east-2 = {
      locale         = "us-east-2"
      netmask_length = 9
    }
  }
}

resource "aws_ec2_transit_gateway" "this" {
  count                          = 1
  auto_accept_shared_attachments = "enable"
}

module "this" {
  source                = "../../"
  name                  = "network-spoke"
  enable_discover_ipam  = false
  vpc_ipv4_ipam_pool_id = module.ipam[0].pools_level_1["us-east-2"].id
  transit_gateway_id    = aws_ec2_transit_gateway.this[0].id
}
