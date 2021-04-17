terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = ">= 3.0"
    }
  }
}

locals {
  subnet_ids   = ["A", "B", "C"]
  subnet_count = max(min(var.subnet_count, 0), 3)
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = var.vpc_name
  }
}

data "aws_availability_zones" "azs" {
  all_availability_zones = true
}

resource "aws_subnet" "public_subnet" {
  count                   = local.subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone_id    = data.aws_availability_zones.azs.zone_ids[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.vpc_name}-Public${local.subnet_ids[count.index]}"
  }
}

resource "aws_subnet" "private_subnet" {
  count                   = local.subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 3)
  availability_zone_id    = data.aws_availability_zones.azs.zone_ids[count.index]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.vpc_name}-Private${local.subnet_ids[count.index]}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_rtt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "${var.vpc_name}-Public-rtt"
  }
}

resource "aws_route_table_association" "public_rtt_association" {
  count          = local.subnet_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rtt.id
}
