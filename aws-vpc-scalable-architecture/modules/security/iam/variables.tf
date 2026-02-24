variable "role_name" {
  description = "Nome da IAM Role"
  type        = string
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

variable "create_instance_profile" {
  description = "Define se deve criar Instance Profile"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para a role"
  type        = map(string)
  default     = {}
}