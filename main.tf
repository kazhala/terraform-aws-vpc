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
  subnet_count = max(min(var.subnet_count, 1), 3)
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
  map_public_ip_on_launch = false

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

data "aws_iam_policy_document" "flowlog_assumerole" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flowlog_permission" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
  }
}

resource "aws_iam_role" "flowlog_role" {
  count              = var.enable_vpc_flowlog ? 1 : 0
  name_prefix        = "vpc-flow-log-role-"
  assume_role_policy = data.aws_iam_policy_document.flowlog_assumerole.json
}

resource "aws_iam_policy" "flowlog_policy" {
  count       = var.enable_vpc_flowlog ? 1 : 0
  name_prefix = "vpc-flow-log-cloudwatch-"
  policy      = data.aws_iam_policy_document.flowlog_permission.json
}

resource "aws_iam_role_policy_attachment" "flowlog_policy_attachment" {
  role       = aws_iam_role.flowlog_role[0].name
  policy_arn = aws_iam_policy.flowlog_policy[0].arn
}

resource "aws_cloudwatch_log_group" "flowlog_group" {
  count             = var.enable_vpc_flowlog ? 1 : 0
  name_prefix       = var.flowlog_log_group_prefix
  retention_in_days = 0
}

resource "aws_flow_log" "vpc_flowlog" {
  count                = var.enable_vpc_flowlog ? 1 : 0
  iam_role_arn         = aws_iam_role.flowlog_role[0].arn
  log_destination_type = "cloud-watch-logs"
  vpc_id               = aws_vpc.vpc.id
  traffic_type         = "ALL"
  log_destination      = aws_cloudwatch_log_group.flowlog_group[0].arn
}
