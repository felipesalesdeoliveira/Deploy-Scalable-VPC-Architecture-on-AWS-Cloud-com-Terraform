variable "name" {
  description = "Nome do Security Group"
  type        = string
}

variable "description" {
  description = "Descrição do Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "ingress_rules" {
  description = "Lista de regras de entrada"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    security_groups = optional(list(string))
  }))
  default = []
}

variable "egress_rules" {
  description = "Lista de regras de saída"
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}