output "internet_test_log_group" {
  description = "log group name for internet test function"
  value       = module.internet_test.cloudwatch_log_group
}

output "mysql_test_log_group" {
  description = "log group name for mysql test function"
  value       = module.mysql_test.cloudwatch_log_group
}