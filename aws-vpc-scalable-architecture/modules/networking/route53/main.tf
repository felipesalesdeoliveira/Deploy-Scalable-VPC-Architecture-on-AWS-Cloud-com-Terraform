resource "aws_route53_zone" "zone" {
  count = var.create_zone ? 1 : 0

  name = var.domain_name

  tags = var.tags
}

resource "aws_route53_record" "record" {
  zone_id = var.create_zone ? aws_route53_zone.zone[0].zone_id : var.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}