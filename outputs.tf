output "aws_vpc" {
  description = "Outputs of AWS VPC."

  value = {
    this = aws_vpc.this
  }
}

output "aws_subnet" {
  description = "All subnets deployed in the VPC."

  value = {
    public  = aws_subnet.public.*
    private = aws_subnet.private.*
  }
}

output "aws_route_table" {
  description = "Route table deployed in the VPC."

  value = {
    public  = aws_route_table.public.*
    private = aws_route_table.private.*
  }
}

output "aws_nacl" {
  description = "NACL deployed in the VPC."
  value = {
    public  = aws_network_acl.public.*
    private = aws_network_acl.private.*
  }
}

output "aws_internet_gateway" {
  description = "Internet gateway deployed for the VPC."
  value = {
    this = aws_internet_gateway.this.*
  }
}
