variable "name" {
  type    = string
  default = "single-service"
}

variable "vpc_id" {
  type = any
}

variable "secret_manager" {
  type    = bool
  default = false
}

variable "rds_engine" {
  type    = string
  default = "postgres"
}

variable "rds_engine_version" {
  type    = string
  default = "14.6"
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

variable "rds_security_groups_db" {
  type = list(string)
}
