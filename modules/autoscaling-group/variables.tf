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

variable "vpc" {
  type    = any
  default = {}
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

variable "iam_role" {
  type    = any
  default = {}
}

variable "log_group" {
  type    = any
  default = {}
}

variable "launch_template" {
  type    = any
  default = {}
}

variable "autoscaling_group" {
  type    = any
  default = {}
}
