variable "name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

variable "parameter" {
  type = any
}
