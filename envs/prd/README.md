## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../../modules/alb | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ../../modules/ecs | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/network | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ../../modules/rds | n/a |
| <a name="module_route53"></a> [route53](#module\_route53) | ../../modules/route53 | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment to deploy to | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The AWS region to deploy to | `string` | `"ap-northeast-1"` | no |
| <a name="input_system"></a> [system](#input\_system) | The system name | `string` | n/a | yes |

## Outputs

No outputs.
