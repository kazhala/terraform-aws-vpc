output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the newly created VPC."
}

output "public_subnets" {
  value       = aws_subnet.public_subnet.*.id
  description = "Public subnet ids."
}

output "private_subnets" {
  value       = aws_subnet.private_subnet.*.id
  description = "Private subnet ids."
}
