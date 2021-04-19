variable "vpc_name" {
  type        = string
  description = "Name tag for the new VPC."
}

variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the new VPC."
}

variable "subnet_count" {
  default     = 3
  type        = number
  description = "Number of subnets to create for each environment (Public, Private, Database)."
}

variable "enable_vpc_flowlog" {
  default     = true
  type        = bool
  description = "Enable flowlog for the new VPC."
}

variable "flowlog_log_group_prefix" {
  default     = "/aws/vpc/flowlogs/"
  type        = string
  description = "CloudWatch log group prefix for flowlogs."
}
