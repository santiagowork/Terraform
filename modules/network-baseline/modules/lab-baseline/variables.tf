variable "environment" {
  type = string
}

variable "project" {
  type = string
}

variable "aws" {
  type = any
}

variable "baseline" {
  type = any
}

variable "bastion" {
  type = any
}

variable "extra_tags" {
  type    = map(string)
  default = {}
}
