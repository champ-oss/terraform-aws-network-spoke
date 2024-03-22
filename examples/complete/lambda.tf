data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "package.zip"
}

# Lambda to test internet by sending a request from spoke to api.seeip.org which responds with our public IP
module "internet_test" {
  source              = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.137-616e273"
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
  environment = {
    URL         = "api.seeip.org"
    SEARCH_DATA = join(",", [for _, value in module.hub[0].nat_gateway_attributes_by_az : value.public_ip])
  }
}

# Lambda which tests connecting from the spoke to a mysql host in the hub
module "mysql_test" {
  source              = "github.com/champ-oss/terraform-aws-lambda.git?ref=v1.0.137-616e273"
  enable_cw_event     = true
  enable_function_url = false
  enable_vpc          = true
  filename            = data.archive_file.this.output_path
  git                 = "network-spoke"
  handler             = "connect_port.handler"
  name                = "mysql-test"
  private_subnet_ids  = module.this.private_subnets_ids
  runtime             = "python3.9"
  schedule_expression = "cron(*/1 * * * ? *)"
  source_code_hash    = data.archive_file.this.output_base64sha256
  timeout             = 15
  vpc_id              = module.this.vpc_id
  environment = {
    HOST = module.mysql.address
    PORT = 3306
  }
}