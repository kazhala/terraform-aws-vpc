variable "name" {
  description = "The VPC Name."
  type        = string
}

variable "cidr_block" {
  description = "The VPC CIDR block."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_newbits" {
  description = <<EOF
Number of additional bits with which to extend the CIDR block for subnets.
If cidr_block is \"/16\" with subnet_cidr_newbits equals 8 then the subnet will have CIDR blocks in \"/24\"."
EOF

  type    = number
  default = 8
}

variable "subnet_count" {
  description = "Number of subnets to create for each type (Public, Private)."
  type        = number
  default     = 3
}

variable "enable_vpc_flow_log" {
  description = "Enable VPC flow logs."
  type        = bool
  default     = true
}

variable "flow_log_log_group_prefix" {
  description = "CloudWatch log group prefix for flow logs. VPC name will be appended after this value."
  type        = string
  default     = "/aws/vpc/flowlogs"
}

variable "flow_log_retention_in_days" {
  description = <<EOF
Specifies the number of days you want to retain log events in the specified log group.
Allowed values: 1 | 3 | 5 | 7 | 14 | 30 | 60 | 90 | 120 | 150 | 180 | 365 | 400 | 545 | 731 | 1827 | 3653 | 0.
If you select 0, the events in the log group are always retained and never expire."
EOF

  type    = string
  default = 0
}

variable "kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional resource tags to apply to applicable resources. Format: {\"key\" = \"value\"}"
  type        = map(string)
  default     = {}
}
