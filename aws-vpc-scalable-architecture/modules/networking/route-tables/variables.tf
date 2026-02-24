variable "name" {
  description = "Nome da Route Table"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "routes" {
  description = "Lista de rotas"
  type = list(object({
    cidr_block = string
    gateway_id = optional(string)
    nat_gateway_id = optional(string)
    transit_gateway_id = optional(string)
  }))
  default = []
}

variable "subnet_ids" {
  description = "Lista de subnets para associar"
  type        = list(string)
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}