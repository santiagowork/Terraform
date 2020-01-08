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

variable "security_group_ingress_rules" {
  type    = any
  default = {}
}

variable "security_group_egress_rules" {
  type    = any
  default = {}
}

variable "vpc" {
  type = object({
    id = string
  })
}

variable "service" {
  type    = any
  default = {}
}

variable "target_tracking_policies" {
  type    = any
  default = {}
}
