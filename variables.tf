variable "vpc_name" {
  type = string
}

variable "cidr_block" {
  default = "10.0.0.0/16"
  type    = string
}

variable "subnet_count" {
  default = 3
  type    = number
}
