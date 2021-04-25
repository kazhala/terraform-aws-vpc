output "vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the newly created VPC."
}

output "public_subnets" {
  value       = aws_subnet.public.*.id
  description = "Public subnet ids."
}

output "private_subnets" {
  value       = aws_subnet.private.*.id
  description = "Private subnet ids."
}
