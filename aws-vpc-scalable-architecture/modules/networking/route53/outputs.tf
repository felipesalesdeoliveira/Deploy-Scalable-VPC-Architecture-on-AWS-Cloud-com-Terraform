output "zone_id" {
  value = try(aws_route53_zone.zone[0].zone_id, var.zone_id)
}

output "record_fqdn" {
  value = aws_route53_record.record.fqdn
}