# Create test database in the hub VPC to test transit gateway connectivity
module "mysql" {
  source                   = "github.com/champ-oss/terraform-aws-mysql.git?ref=v1.0.170-72f9097"
  count                    = var.enabled ? 1 : 0
  name_prefix              = "network-spoke"
  source_security_group_id = aws_security_group.test[0].id
  vpc_id                   = module.hub[0].vpc_attributes.id
  private_subnet_ids       = [for _, value in module.hub[0].private_subnet_attributes_by_az : value.id]
  protect                  = false
  delete_automated_backups = true
  skip_final_snapshot      = true
}

resource "aws_security_group" "test" {
  count       = var.enabled ? 1 : 0
  name_prefix = "test-rds-"
  vpc_id      = module.hub[0].vpc_attributes.id
}