resource "aws_ec2_transit_gateway" "transit_gateway" {
  description = var.name

  tags = merge(
    {
      Name = var.name
    },
    var.tags
  )
}
resource "aws_ec2_transit_gateway_vpc_attachment" "attachments" {
  for_each = {
    for attachment in var.vpc_attachments :
    attachment.name => attachment
  }

  transit_gateway_id = aws_ec2_transit_gateway.transit_gateway.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  tags = {
    Name = each.value.name
  }
}