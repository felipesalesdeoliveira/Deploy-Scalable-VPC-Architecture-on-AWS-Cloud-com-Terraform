variable "name" {
  type = string 
}

variable "vpc_id" { 
  type = string 
}

variable "subnet_ids" {
  type = list(string) 
}

variable "port" {
  type = number 
  default = 80
}

variable "tags" {
  type = map(string) 
  default = {} 
}