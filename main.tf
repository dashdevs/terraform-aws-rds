locals {
  restore_from_snapshot     = var.rds_snapshot_identifier != null ? true : false
  final_snapshot_identifier = var.final_snapshot_identifier != null ? var.final_snapshot_identifier : "${var.name}-final-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  db_password               = var.rds_db_password == null ? random_password.db_master_pass[0].result : var.rds_db_password

  engine_port_map = {
    postgres = 5432
    mysql    = 3306
  }
  db_port = lookup(local.engine_port_map, var.rds_engine, 0)
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.rds_subnets
}

resource "aws_security_group" "ingress" {
  count       = length(var.ingress_security_group_ids) > 0 ? 1 : 0
  name        = "${var.name}-rds-ingress"
  description = "Allow DB connections from specified security groups"
  vpc_id      = var.ingress_vpc_id

  ingress {
    description     = local.db_port == 0 ? "Allow all traffic" : "Allow TCP traffic on port ${local.db_port}"
    from_port       = local.db_port
    to_port         = local.db_port
    protocol        = local.db_port == 0 ? "-1" : "tcp"
    security_groups = var.ingress_security_group_ids
  }
}

resource "aws_db_instance" "database" {
  allocated_storage         = local.restore_from_snapshot ? null : var.rds_allocated_storage
  identifier_prefix         = var.name
  db_name                   = local.restore_from_snapshot ? null : var.rds_db_name
  engine                    = var.rds_engine
  engine_version            = local.restore_from_snapshot ? null : var.rds_engine_version
  instance_class            = var.rds_instance_class
  username                  = var.rds_db_username
  password                  = local.db_password
  db_subnet_group_name      = aws_db_subnet_group.db.name
  vpc_security_group_ids    = concat(var.rds_security_group_ids, aws_security_group.ingress[*].id)
  final_snapshot_identifier = local.final_snapshot_identifier
  snapshot_identifier       = local.restore_from_snapshot ? var.rds_snapshot_identifier : null
  backup_retention_period   = var.backup_retention_period
  multi_az                  = var.multi_az
  publicly_accessible       = var.publicly_accessible
  parameter_group_name      = var.parameter_group_name
}

resource "aws_secretsmanager_secret_version" "db_pass_values" {
  count     = var.create_secret_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.db_pass[count.index].id
  secret_string = jsonencode(
    {
      username = aws_db_instance.database.username
      password = aws_db_instance.database.password
      host     = aws_db_instance.database.address
      database = aws_db_instance.database.db_name
    }
  )
}

resource "random_password" "db_master_pass" {
  count   = var.rds_db_password == null ? 1 : 0
  length  = var.rds_password_lengh
  special = false
}

resource "aws_secretsmanager_secret" "db_pass" {
  count                   = var.create_secret_manager ? 1 : 0
  name                    = "${var.name}-db-secret"
  recovery_window_in_days = 7
}
