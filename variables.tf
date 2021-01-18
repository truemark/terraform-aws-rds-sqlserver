variable "create_instance" {
  description = "Controls if RDS instance should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots."
  type        = bool
  default     = false
}

variable "name" {}

variable "password" {
  default = ""
}

variable "username" {
  default = "admin"
}

variable "engine" {
  default = "sqlserver-se"
}

variable "engine_version" {
  default = "15.00.4073.23.v1"
}

variable "major_engine_version" {
  default = "15.00"
}

variable "family" {
  default = "sqlserver-se-15.0"
}

variable "parameter_group_name" {
  default = "default.sqlserver-se-15.0"
}

variable "option_group_name" {}

variable "instance_class" {
  default = "db.m5.large"
}

variable "publicly_accessible" {
  default = false
}

variable "allocated_storage" {
  default = 20
}

variable "max_allocated_storage" {
  default = 100
}

variable "multi_az" {
  default = true
}

variable "storage_encrypted" {
  default = true
}

variable "timezone" {
  default = "UTC"
}

variable "port" {
  description = "The port on which to accept connections"
  type = string
  default = "1433"
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type = number
  default = 7
}

variable "backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "02:00-03:00"
}

variable "maintenance_window" {
  description = "When to perform DB maintenance"
  type = string
  default = "sun:05:00-sun:06:00"
}

variable "allow_major_version_upgrade" {
  default = false
}

variable "apply_immediately" {
  default = true
}

variable "auto_minor_version_upgrade" {
  default = true
}

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.Collation.html
variable "character_set_name" {
  description = "SQL Server collation to use"
  type = string
  default = "SQL_Latin1_General_CP1_CI_AS"
}

variable "monitoring_role_arn" {
  description = "IAM role for RDS to send enhanced monitoring metrics to CloudWatch"
  type        = string
  default     = ""
}

variable "create_monitoring_role" {
  description = "Whether to create the IAM role for RDS enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 0
}

variable "iam_partition" {
  description = "IAM Partition to use when generating ARN's. For most regions this can be left at default. China/Govcloud use different partitions"
  type        = string
  default     = "aws"
}

variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = null
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported."
  type        = bool
  default     = false
}

variable "create_security_group" {
  description = "Whether to create security group for RDS cluster"
  type        = bool
  default     = true
}

variable "security_group_description" {
  description = "The description of the security group. If value is set to empty string it will contain cluster name in the description."
  type        = string
  default     = "Managed by Terraform"
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to."
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "The existing subnet group name to use"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

variable "license_model" {
  description = "One of license-included, bring-your-own-license, general-public-license"
  default = "license-included"
}
