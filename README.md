# terraform-aws-vpc

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_flow_log.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log) | resource |
| [aws_iam_policy.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.flow_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_network_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.private_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.private_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.public_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.flow_log_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.flow_log_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The VPC CIDR block. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_enable_vpc_flow_log"></a> [enable\_vpc\_flow\_log](#input\_enable\_vpc\_flow\_log) | Enable VPC flow logs. | `bool` | `true` | no |
| <a name="input_flow_log_log_group_prefix"></a> [flow\_log\_log\_group\_prefix](#input\_flow\_log\_log\_group\_prefix) | CloudWatch log group prefix for flow logs. VPC name will be appended after this value. | `string` | `"/aws/vpc/flowlogs"` | no |
| <a name="input_flow_log_retention_in_days"></a> [flow\_log\_retention\_in\_days](#input\_flow\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group.<br>Allowed values: 1 \| 3 \| 5 \| 7 \| 14 \| 30 \| 60 \| 90 \| 120 \| 150 \| 180 \| 365 \| 400 \| 545 \| 731 \| 1827 \| 3653 \| 0.<br>If you select 0, the events in the log group are always retained and never expire." | `string` | `0` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the KMS Key to use when encrypting log data. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The VPC Name. | `string` | n/a | yes |
| <a name="input_subnet_cidr_newbits"></a> [subnet\_cidr\_newbits](#input\_subnet\_cidr\_newbits) | Number of additional bits with which to extend the CIDR block for subnets.<br>If cidr\_block is \"/16\" with subnet\_cidr\_newbits equals 8 then the subnet will have CIDR blocks in \"/24\"." | `number` | `8` | no |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | Number of subnets to create for each type (Public, Private). | `number` | `3` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional resource tags to apply to applicable resources. Format: {"key" = "value"} | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_nacl"></a> [private\_nacl](#output\_private\_nacl) | The ID of the private NACL. |
| <a name="output_private_nacl_arn"></a> [private\_nacl\_arn](#output\_private\_nacl\_arn) | The ARN of the private ACL. |
| <a name="output_private_route_table_arns"></a> [private\_route\_table\_arns](#output\_private\_route\_table\_arns) | List of ARNs of the private route tables. |
| <a name="output_private_route_tables"></a> [private\_route\_tables](#output\_private\_route\_tables) | List of IDs of the private route tables. |
| <a name="output_private_subnet_arns"></a> [private\_subnet\_arns](#output\_private\_subnet\_arns) | List of ARNs of the private subnets. |
| <a name="output_private_subnet_cidr_blocks"></a> [private\_subnet\_cidr\_blocks](#output\_private\_subnet\_cidr\_blocks) | List of cidr blocks of the private subnets. |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of the private subnets. |
| <a name="output_public_nacl"></a> [public\_nacl](#output\_public\_nacl) | The ID of the public NACL. |
| <a name="output_public_nacl_arn"></a> [public\_nacl\_arn](#output\_public\_nacl\_arn) | The ARN of the public ACL. |
| <a name="output_public_route_table_arns"></a> [public\_route\_table\_arns](#output\_public\_route\_table\_arns) | List of ARNs of the public route tables. |
| <a name="output_public_route_tables"></a> [public\_route\_tables](#output\_public\_route\_tables) | List of IDs of the public route tables. |
| <a name="output_public_subnet_arns"></a> [public\_subnet\_arns](#output\_public\_subnet\_arns) | List of ARNs of the public subnets. |
| <a name="output_public_subnet_cidr_blocks"></a> [public\_subnet\_cidr\_blocks](#output\_public\_subnet\_cidr\_blocks) | List of cidr blocks of the public subnets. |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of the public subnets. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
