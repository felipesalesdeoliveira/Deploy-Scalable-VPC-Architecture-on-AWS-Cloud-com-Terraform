output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "CIDR da VPC"
  value       = aws_vpc.vpc.cidr_block
}