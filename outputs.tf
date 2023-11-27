output "public_subnets_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#id"
  value       = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet#id"
  value       = module.vpc.private_subnets_ids
}

output "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id"
  value       = module.vpc.vpc_id
}

output "transit_gateway_vpc_attachment_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.this[0].id
}

output "cidr_block" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc#cidr_block"
  value       = module.vpc.cidr_block
}
