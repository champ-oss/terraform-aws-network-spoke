data "aws_region" "this" {}

data "aws_vpc_ipam_pool" "this" {
  count = var.enable_discover_ipam ? 1 : 0
  filter {
    name   = "description"
    values = [var.ipam_search_description]
  }

  filter {
    name   = "locale"
    values = [data.aws_region.this.name]
  }

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}
