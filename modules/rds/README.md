## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_rds_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_cluster_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_vpc_security_group_egress_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_created_by"></a> [created\_by](#input\_created\_by) | Tag description for resources made by terraform | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name of the database | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | The database engine to use | `string` | `"aurora"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The database engine version to use | `string` | `"5.6.10a"` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | The database engine family to use | `string` | `"aurora-mysql5.7"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of instances to use | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type to use from https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html | `string` | `"db.t3.small"` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | The master username | `string` | n/a | yes |
| <a name="input_private_subnet_availability_zones"></a> [private\_subnet\_availability\_zones](#input\_private\_subnet\_availability\_zones) | The availability zones | `list(string)` | n/a | yes |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | The IDs of the private subnets | `list(string)` | n/a | yes |
| <a name="input_rds_params"></a> [rds\_params](#input\_rds\_params) | The RDS parameters | `map(string)` | <pre>{<br/>  "binlog_format": "ROW",<br/>  "character_set_server": "utf8mb4",<br/>  "collation_server": "utf8mb4_unicode_ci",<br/>  "innodb_flush_log_at_trx_commit": "2",<br/>  "long_query_time": "1",<br/>  "max_connections": "3000",<br/>  "query_cache_type": "0",<br/>  "slow_query_log": "1"<br/>}</pre> | no |
| <a name="input_source_sg_ids"></a> [source\_sg\_ids](#input\_source\_sg\_ids) | The IDs of the security groups to allow access from | `list(string)` | n/a | yes |
| <a name="input_system"></a> [system](#input\_system) | The system name | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

No outputs.
