output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the newly created VPC."
}

output "public_subnets" {
  value       = aws_subnet.public_subnet.*.arn
  description = "Public subnet arns."
}

output "private_subnets" {
  value       = aws_subnet.private_subnet.*.arn
  description = "Private subnet arns."
}
