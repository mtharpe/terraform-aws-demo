![Terraform Testing and Release](https://github.com/mtharpe/terraform-aws-demo/workflows/Terraform%20Testing%20and%20Release/badge.svg)
test

# terraform-aws-demo
Terraform demo in aws


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| terraform | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_ami\_linux | n/a | `string` | `"ami-0fc20dd1da406780b"` | no |
| aws\_ami\_windows | n/a | `string` | `"ami-067317d2d40fd5919"` | no |
| aws\_region | AWS region to launch servers. | `string` | `"us-east-2"` | no |
| chef\_environment | Chef global vars | `string` | `"_default"` | no |
| chef\_pem | n/a | `string` | `""` | no |
| chef\_server\_url | n/a | `string` | `"https://api.chef.io/organizations/axis"` | no |
| chef\_username | n/a | `string` | `"mtharpe"` | no |
| instance\_password | n/a | `string` | `""` | no |
| instance\_username | n/a | `string` | `""` | no |
| key\_name | Desired name of AWS key pair | `string` | `"terraform"` | no |
| local\_ip | n/a | `string` | `"68.44.31.188/32"` | no |
| private\_key | Private key info | `any` | n/a | yes |
| public\_key | Public key info | `any` | n/a | yes |
| server\_runlist | n/a | `string` | `"server::default"` | no |

## Outputs

No output

## License and Maintainer

Maintainer:: HashiCorp (<hello@hashicorp.com>)

Source:: https://github.com/mtharpe/terraform-aws-demo

Issues:: https://github.com/mtharpe/terraform-aws-demo/issues

License:: Apache-2.0
