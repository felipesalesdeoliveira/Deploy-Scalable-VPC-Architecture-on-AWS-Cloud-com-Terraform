output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "app_nlb_dns" {
  value = module.app_layer.nlb_dns_name
}

output "transit_gateway_id" {
  value = module.networking.transit_gateway_id
}
