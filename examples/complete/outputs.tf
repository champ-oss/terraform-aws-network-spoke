output "internet_test_log_group" {
  description = "log group name for internet test function"
  value       = var.enabled ? module.internet_test.cloudwatch_log_group : ""
}

output "mysql_test_log_group" {
  description = "log group name for mysql test function"
  value       = var.enabled ? module.mysql_test.cloudwatch_log_group : ""
}

output "enabled" {
  description = "module enabled"
  value       = var.enabled
}