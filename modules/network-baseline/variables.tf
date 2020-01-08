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

variable "prefixes" {
  type    = any
  default = {}
}

variable "availability_zones_count" {
  type    = number
  default = null
}

variable "availability_zones" {
  type = set(string)
}

variable "vpc" {
  type    = any
  default = {}
}

variable "dns" {
  type    = any
  default = {}
}

variable "enable_nat_gateways" {
  type    = bool
  default = true
}

variable "public_networks" {
  type    = any
  default = {}
}

variable "interface_endpoint_services" {
  type = set(string)
  default = [
    "ssm",
    "ssmmessages",
    "ec2messages",
    "monitoring",
    "logs"
  ]
}

variable "route_endpoint_services" {
  type    = map(object({}))
  default = { "s3" = {} }
}
