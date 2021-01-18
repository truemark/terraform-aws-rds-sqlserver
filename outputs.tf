output "db_instance_arn" {
  description = "The ID of the DB instance"
  value       = element(concat(aws_db_instance.this.*.arn, [""]), 0)
}

output "db_instance_id" {
  description = "The ID of the DB instance"
  value       = element(concat(aws_db_instance.this.*.id, [""]), 0)
}

output "db_instance_resource_id" {
  description = "The Resource ID of the DB instance"
  value       = element(concat(aws_db_instance.this.*.resource_id, [""]), 0)
}

output "db_instance_endpoint" {
  description = "The DB instance endpoint"
  value       = element(concat(aws_db_instance.this.*.endpoint, [""]), 0)
}

output "db_instance_engine_version" {
  description = "The DB engine version"
  value       = element(concat(aws_db_instance.this.*.engine_version, [""]), 0)
}

output "password" {
  description = "The master password"
  value       = element(concat(aws_db_instance.this.*.password, [""]), 0)
  sensitive   = true
}

output "port" {
  description = "The port"
  value       = element(concat(aws_db_instance.this.*.port, [""]), 0)
}

output "username" {
  description = "The master username"
  value       = element(concat(aws_db_instance.this.*.username, [""]), 0)
}

output "db_instance_hosted_zone_id" {
  description = "Route53 hosted zone id of the created instance"
  value       = element(concat(aws_db_instance.this.*.hosted_zone_id, [""]), 0)

}

output "this_security_group_id" {
  description = "The security group ID of the cluster"
  value       = local.rds_security_group_id
}
