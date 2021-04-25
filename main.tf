locals {
  subnet_count = min(max(var.subnet_count, 1), length(data.aws_availability_zones.this.zone_ids))
}

data "aws_availability_zones" "this" {
  all_availability_zones = true
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

resource "aws_subnet" "public" {
  count = local.subnet_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, var.subnet_cidr_newbits, count.index)
  availability_zone_id    = data.aws_availability_zones.this.zone_ids[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = "${var.name}-Public${count.index}"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count = local.subnet_count

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, var.subnet_cidr_newbits, count.index + local.subnet_count)
  availability_zone_id    = data.aws_availability_zones.this.zone_ids[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    {
      "Name" = "${var.name}-Private${count.index}"
    },
    var.tags
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    {
      "Name" = "${var.name}-Public"
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = local.subnet_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
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
  count = var.enable_vpc_flowlog ? 1 : 0

  name_prefix        = "vpc-flowlog-${var.name}-"
  assume_role_policy = data.aws_iam_policy_document.flowlog_assumerole.json

  tags = merge(
    {
      "Name" = "vpc-flowlog-${var.name}"
    },
    var.tags
  )
}

resource "aws_iam_policy" "flowlog_policy" {
  count = var.enable_vpc_flowlog ? 1 : 0

  name_prefix = "vpc-flowlog-${var.name}-"
  policy      = data.aws_iam_policy_document.flowlog_permission.json
}

resource "aws_iam_role_policy_attachment" "flowlog_policy_attachment" {
  count = var.enable_vpc_flowlog ? 1 : 0

  role       = aws_iam_role.flowlog_role[0].name
  policy_arn = aws_iam_policy.flowlog_policy[0].arn
}

resource "aws_cloudwatch_log_group" "flowlog_group" {
  count = var.enable_vpc_flowlog ? 1 : 0

  name_prefix       = "${var.flowlog_log_group_prefix}/${var.name}/"
  retention_in_days = var.flowlog_retention_in_days

  tags = merge(
    {
      "Name" = "vpc-flowlog-${var.name}"
    },
    var.tags
  )
}

resource "aws_flow_log" "vpc_flowlog" {
  count = var.enable_vpc_flowlog ? 1 : 0

  iam_role_arn         = aws_iam_role.flowlog_role[0].arn
  log_destination_type = "cloud-watch-logs"
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  log_destination      = aws_cloudwatch_log_group.flowlog_group[0].arn

  tags = merge(
    {
      "Name" = "vpc-flowlog-${var.name}"
    },
    var.tags
  )
}
