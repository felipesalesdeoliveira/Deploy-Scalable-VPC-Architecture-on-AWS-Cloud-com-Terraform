variable "name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_profile_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = null
}

variable "volume_size" {
  type    = number
  default = 8
}

variable "tags" {
  type    = map(string)
  default = {}
}