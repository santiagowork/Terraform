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

variable "document" {
  type    = any
  default = {}
}

variable "iam_role" {
  type    = any
  default = {}
}
