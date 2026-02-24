variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

variable "enable_versioning" {
  description = "Habilita versionamento"
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}