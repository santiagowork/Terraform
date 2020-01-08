variable "name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "enabled" {
  type    = bool
  default = true
}

variable "log_group" {
  type    = any
  default = {}
}
