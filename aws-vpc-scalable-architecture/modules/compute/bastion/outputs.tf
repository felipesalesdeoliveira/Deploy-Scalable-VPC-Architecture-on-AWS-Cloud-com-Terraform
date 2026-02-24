output "instance_id" {
  value = aws_instance.bastion.id
}

output "public_ip" {
  value = (
    var.allocate_eip ?
    aws_eip.elastic_ip[0].public_ip :
    aws_instance.bastion.public_ip
  )
}

output "key_name" {
  value = var.key_name
}