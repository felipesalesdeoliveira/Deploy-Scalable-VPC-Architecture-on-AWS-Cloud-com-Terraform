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

variable "key_name" {
  type = string
}

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