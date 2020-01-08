variable "application" {
  type = string
}

variable "name" {
  type = string
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

variable "git" {
  type = any
}

variable "log_group" {
  type = any
}

variable "volumes" {
  type = list(object({
    name        = string
    mount_point = string
  }))
  default = []
}

variable "service" {
  type = any
}

variable "security_group_ingress_rules" {
  type    = any
  default = {}
}

variable "security_group_egress_rules" {
  type    = any
  default = {}
}

variable "enable_lb_integration" {
  type    = bool
  default = false
}

variable "lb_integration" {
  type    = any
  default = {}
}

variable "port" {
  type    = number
  default = 8080
}

variable "environment" {
  type    = any
  default = []
}

variable "secrets" {
  type    = any
  default = []
}

variable "image_version" {
  type = string
}

variable "task_definition" {
  type    = any
  default = {}
}
