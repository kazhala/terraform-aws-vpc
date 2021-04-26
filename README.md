# terraform-aws-vpc

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                   | Version |
| ------------------------------------------------------ | ------- |
| <a name="requirement_aws"></a> [aws](#requirement_aws) | >= 3.0  |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 3.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                               | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_cloudwatch_log_group.flowlog_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)                         | resource    |
| [aws_flow_log.vpc_flowlog](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log)                                                   | resource    |
| [aws_iam_policy.flowlog_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                            | resource    |
| [aws_iam_role.flowlog_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                  | resource    |
| [aws_iam_role_policy_attachment.flowlog_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource    |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)                                          | resource    |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table)                                                  | resource    |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association)                          | resource    |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                           | resource    |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                                                            | resource    |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                                                    | resource    |
| [aws_availability_zones.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)                                   | data source |
| [aws_iam_policy_document.flowlog_assumerole](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                   | data source |
| [aws_iam_policy_document.flowlog_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)                   | data source |

## Inputs

| Name                                                                                                         | Description                                                                                                                                                                                                                                                                      | Type          | Default               | Required |
| ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | --------------------- | :------: |
| <a name="input_cidr_block"></a> [cidr_block](#input_cidr_block)                                              | CIDR block for the new VPC.                                                                                                                                                                                                                                                      | `string`      | `"10.0.0.0/16"`       |    no    |
| <a name="input_enable_vpc_flowlog"></a> [enable_vpc_flowlog](#input_enable_vpc_flowlog)                      | Enable flowlog for the new VPC.                                                                                                                                                                                                                                                  | `bool`        | `true`                |    no    |
| <a name="input_flowlog_log_group_prefix"></a> [flowlog_log_group_prefix](#input_flowlog_log_group_prefix)    | CloudWatch log group prefix for flowlogs. VPC name will be appended after this value.                                                                                                                                                                                            | `string`      | `"/aws/vpc/flowlogs"` |    no    |
| <a name="input_flowlog_retention_in_days"></a> [flowlog_retention_in_days](#input_flowlog_retention_in_days) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire. | `string`      | `0`                   |    no    |
| <a name="input_name"></a> [name](#input_name)                                                                | Name for the new VPC.                                                                                                                                                                                                                                                            | `string`      | n/a                   |   yes    |
| <a name="input_subnet_cidr_newbits"></a> [subnet_cidr_newbits](#input_subnet_cidr_newbits)                   | Number of additional bits with which to extend the CIDR block for subnets. If cidr_block is "/16" with subnet_cidr_newbits equals 8 then the subnet will have CIDR blocks in "/24".                                                                                              | `number`      | `8`                   |    no    |
| <a name="input_subnet_count"></a> [subnet_count](#input_subnet_count)                                        | Number of subnets to create for each type (Public, Private).                                                                                                                                                                                                                     | `number`      | `3`                   |    no    |
| <a name="input_tags"></a> [tags](#input_tags)                                                                | Additional resource tags to apply to applicable resources. Format: {"key" = "value"}                                                                                                                                                                                             | `map(string)` | `{}`                  |    no    |

## Outputs

| Name                                                                             | Description                  |
| -------------------------------------------------------------------------------- | ---------------------------- |
| <a name="output_private_subnets"></a> [private_subnets](#output_private_subnets) | Private subnet ids.          |
| <a name="output_public_subnets"></a> [public_subnets](#output_public_subnets)    | Public subnet ids.           |
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id)                            | ID of the newly created VPC. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
