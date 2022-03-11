variable "ingress_cidrs" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidrs" {
  description = "List of IPv4 CIDR ranges to use on all egress rules."
  type        = list(string)
  default     = ["0.0.0.0/0"]
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

variable "instance_name" {
  description = "Name for the MSSQL RDS instance. This will display in the console."
  type        = string
  default     = ""
}

variable "username" {
  description = "The master database account to create."
  type        = string
  default     = "root"
}

variable "engine" {
  description = "The database engine to use."
  type        = string
  default     = "sqlserver-se"
}

variable "engine_version" {
  description = "MSSQL database engine version."
  type        = string
  default     = "15.00.4073.23.v1"
}

variable "major_engine_version" {
  description = "MSSQL major database engine version."
  type        = string
  default     = "15.00"
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = "sqlserver-se-15.0"
}

variable "option_group_name" {
  description = "The name of this specific dbs option group."
  type        = string
  default     = ""
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = "db.m5.large"
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  type = bool
  default = false
}

variable "allocated_storage" {
  description = "Allocated storage size in GB."
  type = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage size in GB."
  type = number
  default     = 65535
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ."
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Specifies if the RDS instance is multi-AZ."
  type        = bool
  default     = true
}

variable "timezone" {
  description = "Time zone of the DB instance. The timezone can only be set on creation (MSSQL specific)."
  type        = string
  default     = "UTC"
}

variable "port" {
  description = "The port on which to accept connections"
  type        = number
  default     = 1433
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  type        = string
  default     = "gp2"
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
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window."
  type        = string
  default     = "03:00-03:30"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed."
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type = bool
  default     = true
}

# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.SQLServer.CommonDBATasks.Collation.html
variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation."
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

# variable "monitoring_role_arn" {
#   description = "IAM role for RDS to send enhanced monitoring metrics to CloudWatch"
#   type        = string
#   default     = ""
# }

variable "create_monitoring_role" {
  description = "Whether to create the IAM role for RDS enhanced monitoring"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected. Setting to 0 disables enhanced monitoring."
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

variable "security_group_tags" {
  description = "Additional tags for the security group"
  type        = map(string)
  default     = {}
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
  description = "The ID of the VPC to provision a db in."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = []
}

variable "license_model" {
  description = "One of license-included, bring-your-own-license, general-public-license"
  default     = "license-included"
}

variable "random_password_length" {
  description = "The length of the password to generate for root user."
  type        = number
  default     = 16
}
variable "store_master_password_as_secret" {
  description = "Toggle on or off storing the root password in Secrets Manager."
  default     = true
}

variable "database_name" {
  description = "The DB name to create. If omitted, no database is created initially."
  type        = string
  default     = ""
}

variable "db_parameters" {
  description = "Map of parameters to use in the aws_db_parameter_group resource"
  type        = list(map(any))
  default     = [{}]
}

variable "kms_key_id" {
  description = "The ARN for the KMS key to encrypt the database."
  type        = string
  default     = ""
}
