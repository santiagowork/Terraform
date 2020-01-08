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

variable "secret" {
  type    = any
  default = {}
}
