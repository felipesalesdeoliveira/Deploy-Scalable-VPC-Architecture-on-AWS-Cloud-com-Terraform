variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

###############################################################################
# KEY PAIR
###############################################################################
variable "key_name" {
  description = "Nome da key pair"
  type        = string
}

variable "create_key_pair" {
  description = "Define se o Terraform deve criar a key pair"
  type        = bool
  default     = false
}

variable "public_key_path" {
  description = "Caminho da chave pública (ex: ~/.ssh/id_rsa.pub)"
  type        = string
  default     = null
}

###############################################################################
# NETWORK
###############################################################################
variable "associate_public_ip" {
  type    = bool
  default = false
}

variable "allocate_eip" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}