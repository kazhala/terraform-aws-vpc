output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "The ARN of the VPC."
  value       = aws_vpc.this.arn
}

output "public_subnets" {
  description = "List of IDs of the public subnets."
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = "List of ARNs of the public subnets."
  value       = aws_subnet.public.*.arn
}

output "public_subnet_cidr_blocks" {
  description = "List of cidr blocks of the public subnets."
  value       = aws_subnet.public.*.cidr_block
}

output "private_subnets" {
  description = "List of IDs of the private subnets."
  value       = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  description = "List of ARNs of the private subnets."
  value       = aws_subnet.private.*.arn
}

output "private_subnet_cidr_blocks" {
  description = "List of cidr blocks of the private subnets."
  value       = aws_subnet.private.*.cidr_block
}

output "public_route_tables" {
  description = "List of IDs of the public route tables."
  value       = aws_route_table.public.*.id
}

output "public_route_table_arns" {
  description = "List of ARNs of the public route tables."
  value       = aws_route_table.public.*.arn
}

output "private_route_tables" {
  description = "List of IDs of the private route tables."
  value       = aws_route_table.private.*.id
}

output "private_route_table_arns" {
  description = "List of ARNs of the private route tables."
  value       = aws_route_table.private.*.arn
}

output "public_nacl" {
  description = "The ID of the public NACL."
  value       = aws_network_acl.public.id
}

output "public_nacl_arn" {
  description = "The ARN of the public ACL."
  value       = aws_network_acl.public.arn
}

output "private_nacl" {
  description = "The ID of the private NACL."
  value       = aws_network_acl.private.id
}

output "private_nacl_arn" {
  description = "The ARN of the private ACL."
  value       = aws_network_acl.private.arn
}
