# TODO Add AD support: domain, domain_iam_role_name
# TODO Add support for io1 and iops
# TODO Later on add support for kms keys
# https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest
module "db" {

  source  = "terraform-aws-modules/rds/aws"
  version = "3.5.0"

  allocated_storage                   = var.allocated_storage
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  backup_retention_period             = var.backup_retention_period
  backup_window                       = var.backup_window
  character_set_name                  = var.character_set_name
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  deletion_protection                 = var.deletion_protection
  engine                              = var.engine
  engine_version                      = var.engine_version
  final_snapshot_identifier           = var.final_snapshot_identifier_prefix
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  identifier                          = var.instance_name
  instance_class                      = var.instance_class
  kms_key_id                          = var.kms_key_id
  license_model                       = var.license_model
  maintenance_window                  = var.maintenance_window
  max_allocated_storage               = var.max_allocated_storage
  monitoring_interval                 = var.monitoring_interval
  monitoring_role_arn                 = aws_iam_role.rds_enhanced_monitoring.id
  multi_az                            = var.multi_az
  # option_group_name                   = var.option_group_name
  parameter_group_name                = aws_db_parameter_group.db_parameter_group.name
  password                            = random_password.root_password.result
  performance_insights_enabled        = var.performance_insights_enabled
  performance_insights_kms_key_id     = var.performance_insights_kms_key_id
  port                                = var.port
  publicly_accessible                 = var.publicly_accessible
  skip_final_snapshot                 = var.skip_final_snapshot
  storage_encrypted                   = true
  storage_type                        = var.storage_type
  subnet_ids                          = var.subnet_ids
  tags                                = var.tags
  timezone                            = var.timezone
  username                            = var.username
  vpc_security_group_ids              = [aws_security_group.db_security_group.id]
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name_prefix = var.instance_name
  description = "Terraform managed parameter group for ${var.instance_name}"
  family      = var.family
  tags        = var.tags
  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

#-----------------------------------------------------------------------------
# these 4 objects below define the root secret.

resource "aws_secretsmanager_secret" "db" {
  count       = var.store_master_password_as_secret ? 1 : 0
  name_prefix = "database/${var.instance_name}/master-"
  description = "Master password for ${var.username} in ${var.instance_name}"
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  count     = var.store_master_password_as_secret ? 1 : 0
  secret_id = aws_secretsmanager_secret.db[count.index].id
  secret_string = jsonencode({
    "username"       = "root"
    "password"       = random_password.root_password.result
    "host"           = module.db.db_instance_address
    "port"           = module.db.db_instance_port
    "dbname"         = module.db.db_instance_name
    "connect_string" = "${module.db.db_instance_endpoint}/${var.database_name}"
    "engine"         = "mssql"
  })
}

resource "random_password" "root_password" {
  length  = var.random_password_length
  special = false
  number  = false
}

data "aws_secretsmanager_secret_version" "db" {
  # There will only ever be one password here. Hard coding the index.
  secret_id  = aws_secretsmanager_secret.db[0].id
  depends_on = [aws_secretsmanager_secret_version.db]
}

#-----------------------------------------------------------------------------

resource "aws_security_group" "db_security_group" {
  name   = var.instance_name
  vpc_id = var.vpc_id
  tags   = var.tags

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidrs
  }

  # TODO Lock this down later
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = var.egress_cidrs
  }
}

################################################################################
# Create an IAM role to allow enhanced monitoring
################################################################################

resource "aws_iam_role" "rds_enhanced_monitoring" {
  name               = "rds-enhanced-monitoring-${lower(var.instance_name)}"
  assume_role_policy = data.aws_iam_policy_document.rds_enhanced_monitoring.json
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}
