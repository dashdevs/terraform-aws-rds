variable "name" {
  type = string
}

variable "rds_engine" {
  type    = string
  default = "postgres"
}

variable "rds_engine_version" {
  type = string
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_subnets" {
  type = list(string)
}

variable "rds_password_lengh" {
  type    = string
  default = "20"
}

variable "rds_security_group_ids" {
  type = list(string)
}

variable "rds_snapshot_identifier" {
  type    = string
  default = null
}

variable "rds_db_name" {
  type = string
}

variable "rds_db_username" {
  type = string
}

variable "create_secret_manager" {
  type    = bool
  default = false
}

variable "rds_allocated_storage" {
  type    = string
  default = "10"
}

variable "final_snapshot_identifier" {
  type    = string
  default = null
}

variable "rds_db_password" {
  type      = string
  sensitive = true
  default   = null
}
