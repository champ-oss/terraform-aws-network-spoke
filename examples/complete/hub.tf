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

# Send internet traffic from all VPCs to the hub
resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway.this[0].association_default_route_table_id
  transit_gateway_attachment_id  = module.hub[0].transit_gateway_attachment_id
}

# Hub VPC for centralizes services and routing all internet traffic through centralized NAT gateways
module "hub" {
  count                   = 1
  source                  = "github.com/aws-ia/terraform-aws-vpc?ref=v4.4.1"
  name                    = "hub"
  az_count                = 2
  vpc_ipv4_ipam_pool_id   = module.ipam[0].pools_level_1["us-east-2"].id
  vpc_ipv4_netmask_length = 18
  transit_gateway_id      = aws_ec2_transit_gateway.this[0].id

  subnets = {
    public = {
      netmask                   = 21
      nat_gateway_configuration = "all_azs"
    }
    private = {
      netmask                 = 21
      connect_to_public_natgw = true
    }
    transit_gateway = {
      netmask                 = 28
      connect_to_public_natgw = true
      tags                    = {}
    }
  }

  transit_gateway_routes = {
    public  = "10.0.0.0/8"
    private = "10.0.0.0/8"
  }
}