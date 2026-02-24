variable "name" {
  description = "Nome base do módulo"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "log_group_name" {
  description = "Nome do Log Group"
  type        = string
}

variable "retention_days" {
  description = "Dias de retenção dos logs"
  type        = number
  default     = 7
}

variable "traffic_type" {
  description = "Tipo de tráfego (ACCEPT | REJECT | ALL)"
  type        = string
  default     = "ALL"
}

variable "tags" {
  type    = map(string)
  default = {}
}