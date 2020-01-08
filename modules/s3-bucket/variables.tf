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

variable "enabled" {
  type    = bool
  default = true
}

variable "bucket" {
  type    = any
  default = {}
}
