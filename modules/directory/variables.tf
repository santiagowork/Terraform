variable "name" {
  type = string
}

variable "random_suffix_length" {
  type    = string
  default = 4
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "aws" {
  type = any
}

variable "secret_kms_key" {
  type    = any
  default = {}
}

variable "secret_kms_alias_prefix" {
  type    = string
  default = ""
}

variable "password_secret" {
  type    = any
  default = {}
}

variable "vpc" {
  type = any
}

variable "directory" {
  type = any
}
