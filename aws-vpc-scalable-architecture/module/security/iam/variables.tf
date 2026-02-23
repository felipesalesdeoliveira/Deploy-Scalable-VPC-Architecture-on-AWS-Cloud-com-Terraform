variable "role_name" {
  type = string
}

variable "assume_role_service" {
  description = "Serviço que pode assumir a role (ex: ec2.amazonaws.com)"
  type        = string
}

variable "managed_policy_arns" {
  description = "Lista de policies gerenciadas da AWS"
  type        = list(string)
  default     = []
}

variable "inline_policy_json" {
  description = "Policy customizada em JSON"
  type        = string
  default     = null
}

variable "tags" {
  type    = map(string)
  default = {}
}