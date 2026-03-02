variable "aws_region" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }

variable "admin_vpc_cidr" { type = string }
variable "app_vpc_cidr" { type = string }

variable "admin_public_subnet_cidrs" { type = list(string) }
variable "app_public_subnet_cidrs" { type = list(string) }
variable "app_private_subnet_cidrs" { type = list(string) }

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "ami_ssm_parameter" {
  type    = string
  default = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "bastion_allowed_ssh_cidrs" {
  type = list(string)
}

variable "bastion_key_name" {
  type    = string
  default = null
}

variable "app_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_asg_min" {
  type    = number
  default = 2
}

variable "app_asg_max" {
  type    = number
  default = 4
}

variable "app_asg_desired" {
  type    = number
  default = 2
}

variable "app_repo_url" {
  type    = string
  default = ""
}

variable "app_repo_branch" {
  type    = string
  default = "main"
}

variable "create_route53_record" {
  type    = bool
  default = false
}

variable "route53_zone_id" {
  type    = string
  default = null
}

variable "route53_record_name" {
  type    = string
  default = null
}
