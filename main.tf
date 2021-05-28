locals {
  subnet_count = min(max(var.subnet_count, 1), length(data.aws_availability_zones.this.zone_ids))
}

data "aws_availability_zones" "this" {
  all_availability_zones = true
}

resource "aws_vpc" "this" {
  # checkov:skip=CKV2_AWS_12:VPC default security group already is secured.
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_subnet" "public" {
  count = local.subnet_count

  # checkov:skip=CKV_AWS_130:This is public subnet.
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.cidr_block, var.subnet_cidr_newbits, count.index)
  availability_zone_id    = data.aws_availability_zones.this.zone_ids[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "${var.name}-Public${count.index}"
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
      Name = "${var.name}-Private${count.index}"
    },
    var.tags
  )
}

resource "aws_network_acl" "public" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public.*.id

  tags = merge(
    {
      Name = "${var.name}-Public"
    },
    var.tags
  )
}

resource "aws_network_acl" "private" {
  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private.*.id

  tags = merge(
    {
      Name = "${var.name}-Private"
    },
    var.tags
  )
}

resource "aws_network_acl_rule" "public_ingress" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_egress" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_ingress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_egress" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.name}-Public"
    },
    var.tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    {
      Name = "${var.name}-Private"
    },
    var.tags
  )
}

resource "aws_route" "igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = local.subnet_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = local.subnet_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

data "aws_iam_policy_document" "flow_log_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "flow_log_permission" {
  statement {
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:${var.flow_log_log_group_prefix}/*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
  }
}

resource "aws_iam_role" "flow_log" {
  count = var.enable_vpc_flow_log ? 1 : 0

  name_prefix        = "vpc-flow-log-${var.name}-"
  assume_role_policy = data.aws_iam_policy_document.flow_log_assume_role.json

  tags = merge(
    {
      Name = "vpc-flow-log-${var.name}"
    },
    var.tags
  )
}

resource "aws_iam_policy" "flow_log" {
  count = var.enable_vpc_flow_log ? 1 : 0

  name_prefix = "vpc-flow-log-${var.name}-"
  policy      = data.aws_iam_policy_document.flow_log_permission.json
}

resource "aws_iam_role_policy_attachment" "flow_log" {
  count = var.enable_vpc_flow_log ? 1 : 0

  role       = aws_iam_role.flow_log[0].name
  policy_arn = aws_iam_policy.flow_log[0].arn
}

resource "aws_cloudwatch_log_group" "flow_log" {
  count = var.enable_vpc_flow_log ? 1 : 0

  name_prefix       = "${var.flow_log_log_group_prefix}/${var.name}/"
  retention_in_days = var.flow_log_retention_in_days
  kms_key_id        = var.kms_key_id

  tags = merge(
    {
      Name = "vpc-flow-log-${var.name}"
    },
    var.tags
  )
}

resource "aws_flow_log" "this" {
  count = var.enable_vpc_flow_log ? 1 : 0

  iam_role_arn         = aws_iam_role.flow_log[0].arn
  log_destination_type = "cloud-watch-logs"
  vpc_id               = aws_vpc.this.id
  traffic_type         = "ALL"
  log_destination      = aws_cloudwatch_log_group.flow_log[0].arn

  tags = merge(
    {
      Name = "vpc-flow-log-${var.name}"
    },
    var.tags
  )
}
