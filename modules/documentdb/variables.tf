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

variable "ebs_kms_key" {
  type    = any
  default = {}
}

variable "ebs_kms_alias_prefix" {
  type    = string
  default = ""
}

variable "secret_kms_key" {
  type    = any
  default = {}
}

variable "secret_kms_alias_prefix" {
  type    = string
  default = ""
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

variable "subnets" {
  type = list(string)
}

variable "parameter_group" {
  type = any
}

variable "cluster" {
  type    = any
  default = {}
}

variable "db_instances" {
  type    = any
  default = {}
}

variable "password_secret" {
  type    = any
  default = {}
}
