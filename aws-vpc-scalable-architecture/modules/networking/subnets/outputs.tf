output "subnet_ids" {
  description = "IDs das subnets"
  value       = aws_subnet.subnet[*].id
}

output "subnet_cidrs" {
  description = "CIDRs das subnets"
  value       = aws_subnet.subnet[*].cidr_block
}