output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC"
}

output "vpc_cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "The CIDR block for the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "The IDs of the private subnets"
}