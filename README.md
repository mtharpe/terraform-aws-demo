[![CircleCI](https://dl.circleci.com/status-badge/img/gh/mtharpe/terraform-aws-demo/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/mtharpe/terraform-aws-demo/tree/main)

# terraform-aws-demo
Terraform demo in aws


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=3.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=3.69.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | app.terraform.io/mtharpe/vpc/aws | >=1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_instance.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_instance.jenkins-01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.mgmt-01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.web-01](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.windows](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_instance_password"></a> [aws\_instance\_password](#input\_aws\_instance\_password) | n/a | `string` | `""` | no |
| <a name="input_aws_instance_username"></a> [aws\_instance\_username](#input\_aws\_instance\_username) | n/a | `string` | `""` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Desired name of AWS key pair | `string` | `"mtharpe-demo-terraform"` | no |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | Private key info | `any` | n/a | yes |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | Public key info | `any` | n/a | yes |
| <a name="input_user"></a> [user](#input\_user) | This is going to be the Org username | `any` | n/a | yes |

## Outputs

No outputs.
