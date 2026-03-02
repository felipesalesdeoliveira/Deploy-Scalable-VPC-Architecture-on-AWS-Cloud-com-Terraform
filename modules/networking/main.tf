resource "aws_ec2_transit_gateway" "this" {
  description = "${var.name} transit gateway"

  tags = merge(var.tags, {
    Name = "${var.name}-tgw"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "admin" {
  subnet_ids         = var.admin_private_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.admin_vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-tgw-admin"
  })
}

resource "aws_ec2_transit_gateway_vpc_attachment" "app" {
  subnet_ids         = var.app_private_subnet_ids
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.app_vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-tgw-app"
  })
}

resource "aws_route" "admin_to_app" {
  count = length(var.admin_private_route_table_ids)

  route_table_id         = var.admin_private_route_table_ids[count.index]
  destination_cidr_block = var.app_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.admin, aws_ec2_transit_gateway_vpc_attachment.app]
}

resource "aws_route" "app_to_admin" {
  count = length(var.app_private_route_table_ids)

  route_table_id         = var.app_private_route_table_ids[count.index]
  destination_cidr_block = var.admin_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.admin, aws_ec2_transit_gateway_vpc_attachment.app]
}

resource "aws_route53_record" "app" {
  count = var.create_route53_record ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = "CNAME"
  ttl     = 300
  records = [var.nlb_dns_name]
}
