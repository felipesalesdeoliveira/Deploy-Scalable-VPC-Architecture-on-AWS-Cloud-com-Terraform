variable "name" {
  description = "Nome da VPC"
  type        = string
}

variable "cidr" {
  description = "Bloco CIDR da VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Habilita suporte a DNS"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Habilita DNS hostnames"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}