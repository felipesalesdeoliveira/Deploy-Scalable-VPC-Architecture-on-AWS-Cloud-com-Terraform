output "instance_id" {
  value = aws_instance.bastion.id
}

output "public_ip" {
  value = try(aws_eip.this[0].public_ip, aws_instance.bastion.public_ip)
}