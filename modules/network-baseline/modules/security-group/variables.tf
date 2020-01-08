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

variable "security_group" {
  type    = any
  default = {}
}

variable "ingress_rules" {
  type    = any
  default = {}
}

variable "egress_rules" {
  type    = any
  default = {}
}
