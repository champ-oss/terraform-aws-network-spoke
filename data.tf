data "aws_region" "this" {
  count = var.enabled ? 1 : 0
}

data "aws_vpc_ipam_pool" "this" {
  count = var.enable_discover_ipam && var.enabled ? 1 : 0
  filter {
    name   = "description"
    values = [var.ipam_search_description]
  }

  filter {
    name   = "locale"
    values = [data.aws_region.this[0].name]
  }

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}
