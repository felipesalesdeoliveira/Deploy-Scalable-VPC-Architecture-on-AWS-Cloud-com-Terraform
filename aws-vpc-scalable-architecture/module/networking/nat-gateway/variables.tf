variable "name" {
  description = "Nome do NAT Gateway"
  type        = string
}

variable "subnet_id" {
  description = "Subnet pública onde o NAT será criado"
  type        = string
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}