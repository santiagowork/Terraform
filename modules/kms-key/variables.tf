variable "name" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "aws" {
  type    = any
  default = {}
}

variable "kms_key" {
  type    = any
  default = {}
}

variable "kms_alias" {
  type    = any
  default = {}
}
