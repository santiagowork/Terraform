variable "name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "vpc" {
  type    = any
  default = {}
}

locals {
  vpc = {
    id         = lookup(var.vpc, "id", null)
    subnet_ids = lookup(var.vpc, "subnet_ids", null)
  }
}

variable "rules" {
  type    = any
  default = {}
}
