variable "name" {
  type = string
}

variable "admin_vpc_id" {
  type = string
}

variable "admin_vpc_cidr" {
  type = string
}

variable "admin_private_subnet_ids" {
  type = list(string)
}

variable "admin_private_route_table_ids" {
  type = list(string)
}

variable "app_vpc_id" {
  type = string
}

variable "app_vpc_cidr" {
  type = string
}

variable "app_private_subnet_ids" {
  type = list(string)
}

variable "app_private_route_table_ids" {
  type = list(string)
}

variable "create_route53_record" {
  type    = bool
  default = false
}

variable "route53_zone_id" {
  type    = string
  default = null
}

variable "route53_record_name" {
  type    = string
  default = null
}

variable "nlb_dns_name" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
