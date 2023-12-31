output "cidr_block" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#cidr_block"
  value       = local.cidr_block
}

output "public_route_table_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table#id"
  value       = local.public_route_table_ids
}

output "private_route_table_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table#id"
  value       = local.private_route_table_ids
}

output "public_subnets_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#id"
  value       = local.public_subnets_ids
}

output "private_subnets_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#id"
  value       = local.private_subnets_ids
}

output "public_ips" {
  description = "List of public NAT IP addresses"
  value       = local.public_ips
}

output "transit_gateway_vpc_attachment_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment"
  value       = module.vpc[0].transit_gateway_attachment_id
}

output "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id"
  value       = local.vpc_id
}
