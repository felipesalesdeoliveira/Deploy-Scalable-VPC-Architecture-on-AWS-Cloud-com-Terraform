output "tgw_id" {
  value = aws_ec2_transit_gateway.transit_gateway.id
}

output "attachment_ids" {
  value = {
    for k, v in aws_ec2_transit_gateway_vpc_attachment.attachments :
    k => v.id
  }
}