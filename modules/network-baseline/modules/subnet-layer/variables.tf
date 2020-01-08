variable "name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "availability_zones" {
  type = set(string)
}

variable "vpc" {
  type    = any
  default = {}
}

variable "networks" {
  type    = any
  default = {}
}

variable "network_acl_ingress_rules" {
  type = any
}

variable "network_acl_egress_rules" {
  type = any
}
