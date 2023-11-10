# terraform rds module


## Usage


**IMPORTANT:** We do not pin modules to versions in our examples because of the
difficulty of keeping the versions in the documentation in sync with the latest released versions.
We highly recommend that in your code you pin the version to the exact version you are
using so that your infrastructure remains stable, and update versions in a
systematic way so that they do not catch you by surprise.

### example for RDS instance:
```
module "database" {
  source                    = "dashdevs/rds/aws"
  name                      = var.name_prefix
  rds_subnets               = var.public_subnets
  rds_security_group_ids    = var.rds_security_group_ids
  rds_db_name               = var.rds_db_name
  rds_db_username           = var.rds_db_username
}

```

<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.34 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.34 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Is used to create names for all internal resources of a module. It represents a prefix that will be added to the names of all internal resources to ensure their uniqueness within the module. | `string` | `n/a` | yes |
| <a name="input_rds_engine"></a> [rds\_engine](#input\_rds\_engine) | The database engine to use. For supported values, see the Engine parameter in [API action CreateDBInstance](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html#:~:text=Required%3A%20Yes-,Engine,-The%20database%20engine) | `string` | `postgres` | no |
| <a name="input_rds_engine_version"></a> [rds\_engine\_version](#input\_rds\_engine\_version) | The database engine version to use | `string` | `15.4-R3` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | The instance type of the RDS instance | `string` |`db.t3.micro`| no |
| <a name="input_rds_subnets"></a> [rds\_subnets](#input\_rds\_subnets) | List of subnets id. The DB instance will be created in the VPC associated with these subnets. | `list(string)` |`n/a`| yes |
| <a name="input_rds_password_lengh"></a> [ec2\_rds\_password\_lengh](#input\_rds\_password\_lengh) | Database user password length | `number` |`20`| no |
| <a name="input_rds_security_group_ids"></a> [rds\_security\_group\_ids](#input\_rds\_security\_group\_ids) | List of security group identifiers that will be associated with the RDS instance.  | `list(string)` |`n/a`| yes |
| <a name="input_rds_snapshot_restore"></a> [rds\_snapshot\_restore](#input\_rds\_snapshot\_restore) | Switch to choose whether to restore the database from a snapshot or create the database. | `bool` |`false`| no |
| <a name="input_rds_snapshot_identifier"></a> [rds\_snapshot\_identifier](#input\_rds\_snapshot\_identifier) | The database snapshot identifier. If `rds_snapshot_restore` is set `true` and `rds_snapshot_identifier` is not set then database will be restored from final snapshot | `string` |`null`| no |
| <a name="input_rds_db_name"></a> [rds\_db\_name](#input\_rds\_db\_name) | The name of the database | `string` |`n/a`| yes |
| <a name="input_rds_db_username"></a> [rds\_db\_username](#input\_rds\_db\_username) | The username of the database user | `string` |`n/a`| yes |
| <a name="input_secret_manager"></a> [secret\_manager](#input\_secret\_manager) | Enables the creation of a secret resource in Secret Manager | `bool` |`false`| no |
| <a name="input_rds_allocated_storage"></a> [rds\_allocated\_storage](#input\_rds\_allocated\_storage) | Database allocated storage capacity | `string` |`10`| no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | 
The name of the final database snapshot that will be created when the database is deleted. If set is `null` or not set then will be set as `${var.name}-final` | `string` |`null`| no |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_db_username"></a> [rds\_db\_username](#output\_rds\_db\_username) | The username of the database user |
| <a name="output_rds_db_address"></a> [rds\_db\_address](#output\_rds\_db\_address) | The Endpoint of the database |
| <a name="output_rds_db_name"></a> [rds\_db\_name](#output\_rds\_db\_name) | The name of the database |
| <a name="output_rds_db_password"></a> [rds\_db\_password](#output\_rds\_db\_password) | The password of the database user |