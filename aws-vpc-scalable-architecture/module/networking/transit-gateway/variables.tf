variable "name" {
  type        = string
  description = "Nome do Transit Gateway"
}

variable "vpc_attachments" {
  description = "Lista de VPCs para anexar ao TGW"
  type = list(object({
    vpc_id     = string
    subnet_ids = list(string)
    name       = string
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}