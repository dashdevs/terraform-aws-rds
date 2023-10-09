output "rds_db_username" {
  value = aws_db_instance.database.username
}

output "rds_db_address" {
  value = aws_db_instance.database.address
}

output "rds_db_name" {
  value = aws_db_instance.database.db_name
}

output "rds_db_password" {
  value     = aws_db_instance.database.password
  sensitive = true
}
