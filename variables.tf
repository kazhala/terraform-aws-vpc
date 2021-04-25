variable "name" {
  type        = string
  description = "Name for the new VPC."
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the new VPC."
}

variable "subnet_cidr_newbits" {
  default     = 8
  type        = number
  description = "Number of additional bits with which to extend the CIDR block for subnets. If cidr_block is \"/16\" with subnet_cidr_newbits equals 8 then the subnet will have CIDR blocks in \"/24\"."
}

variable "subnet_count" {
  default     = 3
  type        = number
  description = "Number of subnets to create for each type (Public, Private)."
}

variable "enable_vpc_flowlog" {
  default     = true
  type        = bool
  description = "Enable flowlog for the new VPC."
}

variable "flowlog_log_group_prefix" {
  default     = "/aws/vpc/flowlogs"
  type        = string
  description = "CloudWatch log group prefix for flowlogs. VPC name will be appended after this value."
}

variable "flowlog_retention_in_days" {
  default     = 0
  type        = string
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Additional resource tags to apply to applicable resources. Format: {\"key\" = \"value\"}"
}
