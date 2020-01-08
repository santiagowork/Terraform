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

variable "vpc" {
  type = any
}

variable "security_group" {
  type    = any
  default = {}
}

variable "security_group_ingress_rules" {
  type    = any
  default = {}
}

variable "security_group_egress_rules" {
  type    = any
  default = {}
}

variable "elasticache" {
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
