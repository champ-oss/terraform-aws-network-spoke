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

# Hub VPC for routing all internet traffic through centralized NAT gateways
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
    transit_gateway = {
      netmask                 = 28
      connect_to_public_natgw = true
      tags                    = {}
    }
  }

  transit_gateway_routes = {
    public = "10.0.0.0/8"
  }
}

# Send internet traffic from all VPCs to the hub
resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_route_table_id = aws_ec2_transit_gateway.this[0].association_default_route_table_id
  transit_gateway_attachment_id  = module.hub[0].transit_gateway_attachment_id
}

module "this" {
  source                = "../../"
  name                  = "network-spoke"
  enable_discover_ipam  = false
  vpc_ipv4_ipam_pool_id = module.ipam[0].pools_level_1["us-east-2"].id
  transit_gateway_id    = aws_ec2_transit_gateway.this[0].id
}

data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "package.zip"
}

module "internet_test" {
  source              = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.133-c385eba"
  enable_cw_event     = true
  enable_function_url = false
  enable_vpc          = true
  filename            = data.archive_file.this.output_path
  git                 = "network-spoke"
  handler             = "get_url.handler"
  name                = "internet-test"
  private_subnet_ids  = module.this.private_subnets_ids
  runtime             = "python3.9"
  schedule_expression = "cron(*/1 * * * ? *)"
  source_code_hash    = data.archive_file.this.output_base64sha256
  timeout             = 15
  vpc_id              = module.this.vpc_id
  environment         = { URL = "api.seeip.org" }
}

output "internet_test_log_group" {
  description = "log group name for internet test function"
  value       = module.internet_test.cloudwatch_log_group
}

output "public_ips" {
  description = "List of public NAT IP addresses"
  value       = [for _, value in module.hub[0].nat_gateway_attributes_by_az : value.public_ip]
}


