locals {
  tags = {
    git       = var.name
    cost      = "shared"
    creator   = "terraform"
    component = "spoke"
  }
  vpc_id                  = module.vpc[0].vpc_attributes.id
  cidr_block              = module.vpc[0].vpc_attributes.cidr_block
  public_subnets_ids      = [for _, value in module.vpc[0].public_subnet_attributes_by_az : value.id]
  private_subnets_ids     = [for _, value in module.vpc[0].private_subnet_attributes_by_az : value.id]
  private_route_table_ids = [for _, value in module.vpc[0].rt_attributes_by_type_by_az.private : value.id]
  public_route_table_ids  = [for _, value in module.vpc[0].rt_attributes_by_type_by_az.public : value.id]
  public_ips              = [for _, value in module.vpc[0].nat_gateway_attributes_by_az : value.public_ip]
}

module "vpc" {
  count                   = 1
  source                  = "github.com/aws-ia/terraform-aws-vpc?ref=v4.4.1"
  name                    = var.name
  az_count                = var.availability_zones_count
  vpc_ipv4_ipam_pool_id   = var.vpc_ipv4_ipam_pool_id != null ? var.vpc_ipv4_ipam_pool_id : data.aws_vpc_ipam_pool.this[0].id
  vpc_ipv4_netmask_length = var.vpc_ipv4_netmask_length
  transit_gateway_id      = var.transit_gateway_id
  tags                    = merge(local.tags, var.tags)

  subnets = {
    public = {
      netmask                   = var.subnet_ipv4_netmask_length
      nat_gateway_configuration = "none"
      tags                      = merge({ Type = "Public" }, local.tags)
    }
    private = {
      netmask = var.subnet_ipv4_netmask_length
      tags    = merge({ Type = "Private" }, local.tags)
    }
    transit_gateway = {
      netmask = 28
      tags    = merge({ Type = "TGW" }, local.tags)
    }
  }

  transit_gateway_routes = {
    private = "0.0.0.0/0"
  }

  vpc_flow_logs = {
    log_destination_type = "cloud-watch-logs"
    retention_in_days    = 180
  }
}

resource "aws_default_network_acl" "this" {
  count                  = 1
  default_network_acl_id = module.vpc[0].vpc_attributes.default_network_acl_id

  dynamic "ingress" {
    for_each = toset(var.ingress_acl_allow_rules)
    content {
      protocol   = -1
      rule_no    = ingress.value.rule_no
      action     = "allow"
      cidr_block = ingress.value.cidr_block
      from_port  = 0
      to_port    = 0
    }
  }

  # Always allow all traffic from local CIDR block
  ingress {
    protocol   = -1
    rule_no    = 10
    action     = "allow"
    cidr_block = local.cidr_block
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_vpc_endpoint" "s3" {
  count             = var.enable_s3_vpc_endpoint ? 1 : 0
  vpc_endpoint_type = "Gateway"
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.this.name}.s3"
  route_table_ids   = local.private_route_table_ids
  tags              = merge({ Name : "${var.name}-s3" }, local.tags, var.tags)
}