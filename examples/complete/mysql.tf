# Create test database in the hub VPC to test transit gateway connectivity
module "mysql" {
  source                   = "github.com/champ-oss/terraform-aws-mysql.git?ref=v1.0.170-72f9097"
  name_prefix              = "network-spoke"
  source_security_group_id = aws_security_group.test.id
  vpc_id                   = module.hub[0].vpc_attributes.id
  private_subnet_ids       = [for _, value in module.hub[0].private_subnet_attributes_by_az : value.id]
  protect                  = false
  delete_automated_backups = true
  skip_final_snapshot      = true
}

resource "aws_security_group" "test" {
  name_prefix = "test-rds-"
  vpc_id      = module.hub[0].vpc_attributes.id
}