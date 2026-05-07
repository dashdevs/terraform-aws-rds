variable "name" {
  type = string
}

variable "rds_engine" {
  type    = string
  default = "postgres"
}

variable "rds_engine_version" {
  type    = string
  default = null
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
  type    = list(string)
  default = []
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

variable "rds_storage_autoscaling_max_gib" {
  type        = number
  default     = null

  validation {
    condition     = var.rds_storage_autoscaling_max_gib == null || var.rds_storage_autoscaling_max_gib >= tonumber(var.rds_allocated_storage)
    error_message = "rds_storage_autoscaling_max_gib must be greater than or equal to rds_allocated_storage."
  }
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

variable "ingress_vpc_id" {
  type    = string
  default = null
  validation {
    condition     = var.ingress_vpc_id != null || length(var.ingress_security_group_ids) > 0
    error_message = "ingress_vpc_id must be set if ingress_security_group_ids is not empty."
  }
}

variable "ingress_security_group_ids" {
  type    = list(string)
  default = []
}

variable "backup_retention_period" {
  type    = number
  default = 0
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "parameter_group_name" {
  type    = string
  default = null
}

variable "replicate_source_db" {
  type    = string
  default = null
}

variable "db_subnet_group_name" {
  type        = string
  default     = null
  description = "Use an existing DB subnet group instead of creating one. When set, rds_subnets is ignored."
}

variable "storage_encrypted" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = []
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}

variable "performance_insights_kms_key_id" {
  type    = string
  default = null
}

variable "performance_insights_retention_period" {
  type    = number
  default = null
}
