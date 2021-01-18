locals {
  master_password = var.password == "" ? element(concat(random_password.master_password.*.result, [""]), 0) : var.password
  rds_enhanced_monitoring_arn  = var.create_monitoring_role ? join("", aws_iam_role.rds_enhanced_monitoring.*.arn) : var.monitoring_role_arn
  rds_enhanced_monitoring_name = join("", aws_iam_role.rds_enhanced_monitoring.*.name)
  rds_security_group_id = join("", aws_security_group.this.*.id)
  db_subnet_group_name = var.db_subnet_group_name == "" ? join("", aws_db_subnet_group.this.*.name) : var.db_subnet_group_name
}

resource "aws_db_subnet_group" "this" {
  count = var.create_instance && var.db_subnet_group_name == "" ? 1 : 0

  name        = var.name
  description = "For RDS ${var.name}"
  subnet_ids  = var.subnets

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "random_password" "master_password" {
  count = var.create_instance && var.password == "" ? 1 : 0
  length = 10
  special = false
}

resource "aws_db_instance" "this" {
  identifier = var.name
  count = var.create_instance ? 1 : 0
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  # TODO Add support for io1 and iops
  storage_type = "gp2"
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  publicly_accessible = var.publicly_accessible
  character_set_name = var.character_set_name
  username = var.username
  password = local.master_password
  parameter_group_name = var.parameter_group_name
  option_group_name = var.option_group_name
  multi_az = var.multi_az
  # TODO Later on add support for kms keys
  storage_encrypted = true
  timezone = var.timezone
  port = var.port
  backup_retention_period = var.backup_retention_period
  backup_window = var.backup_window
  maintenance_window = var.maintenance_window
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier_prefix
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  performance_insights_enabled = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  # TODO Add AD support: domain, domain_iam_role_name
  monitoring_role_arn = local.rds_enhanced_monitoring_arn
  monitoring_interval = var.monitoring_interval
  tags = var.tags
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  license_model = var.license_model
  db_subnet_group_name = local.db_subnet_group_name
  vpc_security_group_ids = [local.rds_security_group_id]
}

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.create_instance && var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0
  name               = "rds-enhanced-monitoring-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.monitoring_rds_assume_role.json
  permissions_boundary = var.permissions_boundary
  tags = merge(var.tags, {
    Name = "sqlserver-${var.name}"
  })
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.create_instance && var.create_monitoring_role && var.monitoring_interval > 0 ? 1 : 0
  role       = local.rds_enhanced_monitoring_name
  policy_arn = "arn:${var.iam_partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_security_group" "this" {
  count = var.create_instance && var.create_security_group ? 1 : 0

  name_prefix = "${var.name}-"
  vpc_id      = var.vpc_id

  description = var.security_group_description == "" ? "Control traffic to/from RDS ${var.name}" : var.security_group_description

  tags = merge(var.tags, {
    Name = "sqlserver-${var.name}"
  })
}

resource "aws_security_group_rule" "default_ingress" {
  count = var.create_instance && var.create_security_group ? length(var.allowed_security_groups) : 0

  description = "From allowed SGs"

  type                     = "ingress"
  from_port                = element(concat(aws_db_instance.this.*.port, [""]), 0)
  to_port                  = element(concat(aws_db_instance.this.*.port, [""]), 0)
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = local.rds_security_group_id
}

resource "aws_security_group_rule" "cidr_ingress" {
  count = var.create_instance && var.create_security_group && length(var.allowed_cidr_blocks) > 0 ? 1 : 0

  description = "From allowed CIDRs"

  type              = "ingress"
  from_port         = element(concat(aws_db_instance.this.*.port, [""]), 0)
  to_port           = element(concat(aws_db_instance.this.*.port, [""]), 0)
  protocol          = "tcp"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = local.rds_security_group_id
}
