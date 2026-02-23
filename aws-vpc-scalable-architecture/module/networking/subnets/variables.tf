variable "name" {
  description = "Nome base das subnets"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "cidrs" {
  description = "Lista de CIDRs das subnets"
  type        = list(string)
}

variable "azs" {
  description = "Lista de Availability Zones"
  type        = list(string)
}

variable "public" {
  description = "Define se a subnet é pública"
  type        = bool
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}