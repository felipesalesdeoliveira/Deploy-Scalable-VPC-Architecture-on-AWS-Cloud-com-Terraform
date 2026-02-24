variable "create_zone" {
  description = "Define se o Hosted Zone será criado"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Nome do domínio (ex: example.com)"
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Zone ID existente (caso não crie nova zone)"
  type        = string
  default     = null
}

variable "record_name" {
  description = "Nome do registro (ex: app.example.com)"
  type        = string
}

variable "alb_dns_name" {
  description = "DNS do ALB"
  type        = string
}

variable "alb_zone_id" {
  description = "Zone ID do ALB"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}