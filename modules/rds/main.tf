resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.rds_subnets
}

resource "aws_security_group" "db" {
  name        = "allow-psql"
  description = "Allow Postgress traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.rds_security_groups_db
  }
}

data "aws_db_snapshot" "snapshot" {
  db_snapshot_identifier = "${var.name}-final"
  most_recent            = true
}

resource "aws_db_instance" "database" {
  allocated_storage         = 10
  identifier                = "${var.name}-db"
  db_name                   = var.name
  engine                    = var.rds_engine         #"postgres"
  engine_version            = var.rds_engine_version #"14.6"
  instance_class            = var.rds_instance_class #"db.t3.micro"
  username                  = "${var.name}_admin"
  password                  = random_password.db_master_pass.result
  final_snapshot_identifier = "${var.name}-final"
  snapshot_identifier       = length(data.aws_db_snapshot.snapshot) > 0 ? data.aws_db_snapshot.snapshot.id : null
  db_subnet_group_name      = aws_db_subnet_group.db.name
  vpc_security_group_ids    = [aws_security_group.db.id]
}

resource "aws_secretsmanager_secret_version" "db_pass_values" {
  count     = var.secret_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.db_pass[count.index].id
  secret_string = jsonencode(
    {
      username = aws_db_instance.database.username
      password = aws_db_instance.database.password
      host     = aws_db_instance.database.endpoint
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
