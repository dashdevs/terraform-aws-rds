resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.rds_subnets
}

resource "aws_db_instance" "database" {
  allocated_storage         = var.rds_snapshot_restore ? null : var.rds_allocated_storage
  identifier                = var.name
  db_name                   = var.rds_db_name
  engine                    = var.rds_engine
  engine_version            = var.rds_snapshot_restore ? null : var.rds_engine_version
  instance_class            = var.rds_instance_class
  username                  = var.rds_snapshot_restore ? null : var.rds_db_username
  password                  = var.rds_snapshot_restore ? null : random_password.db_master_pass.result
  db_subnet_group_name      = aws_db_subnet_group.db.name
  vpc_security_group_ids    = var.rds_security_group_ids
  final_snapshot_identifier = "${var.name}-final"
  snapshot_identifier       = var.rds_snapshot_restore ? "${var.name}-final" : null
}

resource "aws_secretsmanager_secret_version" "db_pass_values" {
  count     = var.secret_manager ? 1 : 0
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
  length  = var.rds_password_lengh
  special = false
}

resource "aws_secretsmanager_secret" "db_pass" {
  count = var.secret_manager ? 1 : 0
  name  = "${var.name}-db-secret"
}
