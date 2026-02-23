variable "name" {
  description = "Nome do Internet Gateway"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "tags" {
  description = "Tags adicionais"
  type        = map(string)
  default     = {}
}