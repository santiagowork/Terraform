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

variable "policy" {
  type    = any
  default = null
}

variable "role_names" {
  type    = set(string)
  default = []
}
