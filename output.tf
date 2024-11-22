output "vpc_arn" {
  description = "ARN value of the created VPC"
  value       = aws_vpc.custom_vpc.arn
}

output "vpc_id" {
  description = "VPC ID of  the VPC we created"
  value       = aws_vpc.custom_vpc.id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for all the private subnets we created in VPC"
  value       = aws_subnet.private_subnet.*.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs for all the public subnets we created in VPC"
  value       = aws_subnet.public_subnet.*.id
}