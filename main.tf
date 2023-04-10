module "rds" {
  source                 = "./modules/rds"
  name                   = var.name
  vpc_id                 = var.vpc_id
  rds_subnets            = var.rds_subnets
  rds_engine             = var.rds_engine
  rds_engine_version     = var.rds_engine_version
  rds_instance_class     = var.rds_instance_class
  rds_password_lengh     = var.rds_password_lengh
  rds_security_groups_db = var.rds_security_groups_db
}
